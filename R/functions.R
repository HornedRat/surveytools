require(dplyr)
require(tidyr)
require(tibble)
require(rlang)
require(openxlsx)
require(gtools)
require(foreign)
require(stringr)

#function for mixed sorting

mixedrank <- function(x) order(gtools::mixedorder(x))

#function for reading data

# get_data <- function(sav_file) {
#     labels_df <- read.spss(sav_file, use.value.labels = TRUE, to.data.frame = TRUE)
#     values_df <- read.spss(sav_file, use.value.labels = FALSE, to.data.frame = TRUE)
#
#     return(list(labels = labels_df, values = values_df))
# }


#function that generates a dictionary of questions

get_dictionary <- function(df) {

    data.frame(attr(df, 'variable.labels')) %>%
        rownames_to_column("variable") %>%
        rename(label = 2)
}


#function that creates a table with given rows and columns

#todo - averages for numeric
#auto all vars
#todo - multiple banners

make_tab <- function(df, ..., banner = NULL) {

    dict <- get_dictionary(df)

    ban <- enquo(banner)

    suppressMessages(
    total_tab <- df %>%
        select(...) %>%
        pivot_longer(cols = everything(), names_to = "variable") %>%
        group_by(variable) %>%
        mutate(n = n()) %>%
        group_by(variable, value) %>%
        summarise(count = n(), n = first(n)) %>%
        mutate(perc = count / n) %>%
        ungroup()
    )

    total_n <- min(total_tab$n)

    suppressMessages(
    total_tab <- total_tab %>%
        rename(total = perc) %>%
        mutate(total = ifelse(is.na(total), 0, total)) %>%
        left_join(dict) %>%
        select(variable, label, value, total) %>%
        arrange(mixedrank(variable)) %>%
        add_row(value = "Sample size", total = total_n, .before = 1)
    )

    if(!quo_is_null(ban)) {

        suppressMessages(
        banner_tab <- df %>%
            select(..., {{banner}}) %>%
            pivot_longer(cols = -{{banner}}, names_to = "variable") %>%
            group_by(variable, {{banner}}) %>%
            mutate(n = n()) %>%
            group_by(variable, {{banner}}, value) %>%
            summarise(count = n(), n = first(n))
        )

        suppressMessages(
        banner_sample <- banner_tab %>%
            group_by({{banner}}) %>%
            summarise(sample_size = min(n)) %>%
            pivot_wider(names_from = {{banner}}, values_from = sample_size) %>%
            mutate(variable = NA, label=NA, value="Sample size", total = total_n) %>%
            select(variable, label, value, total, everything())
        )

        suppressMessages(
        banner_tab <- banner_tab %>%
            mutate(perc = count / n) %>%
            pivot_wider(id_cols = c(variable, value), names_from = {{banner}}, values_from = perc, values_fill = 0) %>%
            left_join(total_tab) %>%
            left_join(dict) %>%
            arrange(mixedrank(variable))
        )

        banner_tab <- bind_rows(banner_sample, banner_tab)

        return(banner_tab)
    } else {
        return(total_tab)
    }


}

#function for tables with means

make_tab_num <- function(df, ..., banner = NULL) {

    dict <- get_dictionary(df)

    ban <- enquo(banner)

    suppressMessages(
        total_tab <- df %>%
            select(...) %>%
            pivot_longer(cols = everything(), names_to = "variable") %>%
            group_by(variable) %>%
            summarise(n = n(), mean = mean(value, na.rm = T)) %>%
            ungroup()
    )

    total_n <- min(total_tab$n)

    suppressMessages(
        total_tab <- total_tab %>%
            rename(total = mean) %>%
            left_join(dict) %>%
            mutate(value = "mean") %>%
            select(variable, label, value, total) %>%
            arrange(mixedrank(variable)) %>%
            add_row(value = "Sample size", total = total_n, .before = 1)
    )

    if(!quo_is_null(ban)) {

        suppressMessages(
            banner_tab <- df %>%
                select(..., {{banner}}) %>%
                pivot_longer(cols = -{{banner}}, names_to = "variable") %>%
                group_by(variable, {{banner}}) %>%
                summarise(n = n(), mean = mean(value, na.rm = T))
        )

        suppressMessages(
            banner_sample <- banner_tab %>%
                group_by({{banner}}) %>%
                summarise(sample_size = min(n)) %>%
                pivot_wider(names_from = {{banner}}, values_from = sample_size) %>%
                mutate(variable = NA, label=NA, value="Sample size", total = total_n) %>%
                select(variable, label, value, total, everything())
        )

        suppressMessages(
            banner_tab <- banner_tab %>%
                mutate(value = "mean") %>%
                pivot_wider(id_cols = c(variable, value), names_from = {{banner}}, values_from = mean) %>%
                left_join(total_tab) %>%
                left_join(dict) %>%
                arrange(mixedrank(variable))
        )

        banner_tab <- bind_rows(banner_sample, banner_tab)

        return(banner_tab)
    } else {
        return(total_tab)
    }

}

#function to write and format data to an excel sheet

write_tab <- function(tabs, tests = NULL, filename) {

    #tabs - a LIST of tables
    #tests - a corresponding list of tests

    pct = createStyle(numFmt="0%")
    smpl = createStyle(numFmt="0")
    wb <- createWorkbook()
    addWorksheet(wb, "tables")

    start_row <- 1

    for(t in tabs) {

        writeDataTable(wb, "tables", t, startRow = start_row, startCol = 1)

        addStyle(wb, "tables", style=pct, cols=4:ncol(t),
                                          rows=(start_row+2):(start_row+nrow(t)),
                                          gridExpand=TRUE)

        addStyle(wb, "tables", style=smpl, cols=4:ncol(t),
                 rows=(start_row+1),
                 gridExpand=TRUE)

        setColWidths(wb, "tables", 2, 50)

        start_row <- start_row + nrow(t) + 2
    }

    if (!is.null(tests)) {

        addWorksheet(wb, "tests")

        start_row <- 1

        for(t in tests) {

            writeDataTable(wb, "tests", t, startRow = start_row, startCol = 1)

            setColWidths(wb, "tests", 2, 50)

            start_row <- start_row + nrow(t) + 2
        }

    }

    saveWorkbook(wb, file = filename, overwrite = TRUE)
}


# function to compute midpoints of an interval

#helper function that works on a string

midpoint_string <- function(string) {

    matches <- gregexpr("[+-]?\\d+(?:[.,]\\d*)?", string)

    n_numbers <- length(matches[[1]])

    if (matches[[1]][1]==-1) {
        message(paste("no numbers found in", string))
        return(NA)
    } else if (n_numbers==1) {
        # start of first number
        s <- matches[[1]][1]
        # length of first number
        l <- attr(matches[[1]], "match.length")[1]
        #first number
        num_string1 <- substr(string, s, s+l-1)
        num1 <- as.numeric(gsub(",", ".", num_string1))
        return(num1)
    } else if (n_numbers==2) {
        # start of first number
        s <- matches[[1]][1]
        # length of first number
        l <- attr(matches[[1]], "match.length")[1]
        #first number
        num_string1 <- substr(string, s, s+l-1)
        num1 <- as.numeric(gsub(",", ".", num_string1))

        # start of second number
        s <- matches[[1]][2]
        # length of second number
        l <- attr(matches[[1]], "match.length")[2]
        #first number
        num_string2 <- substr(string, s, s+l-1)
        num2 <- as.numeric(gsub(",", ".", num_string2))

        return(mean(c(num1, num2)))
    } else if (n_numbers>2) {
        message(paste("more than 2 numbers found in", string))
        return(NA)
    }
}

# vectorized midpoint function to use in a dplyr::mutate

midpoints <- function(vector) {
    sapply(vector, midpoint_string)
}

# function to get prop.test results for 2 samples

get_prop_test <- function(proportions, samples, confidence) {

    successes <- samples * proportions

    # get a matrix of Higher or Lower
    hl <- matrix(nrow = length(proportions), ncol = length(proportions))

    for (i in 1:length(proportions)) {
    hl[i,] <- ifelse(proportions > proportions[i], "H",
                        ifelse(proportions < proportions[i], "L", ""))
    }

    # get a matrix of sig/not sig
    p_table <- pairwise.prop.test(successes, samples)$p.value
    p_table2 <- rbind(rep(NA, dim(p_table)[2]), p_table)
    p_table2 <- cbind(p_table2, rep(NA, dim(p_table2)[1]))
    p_table2[upper.tri(p_table2)] <- t(p_table2)[upper.tri(p_table2)]
    sig_table <- p_table2 < (1-confidence)

    #get test result

    test_result <- vector("character", length = length(proportions))

    for (i in 1:length(proportions)) {

        comps <- hl[,i]
        sig <- sig_table[i,]

        ht <- grep(TRUE, sig == TRUE & comps == 'H')
        lt <- grep(TRUE, sig == TRUE & comps == 'L')

        ht_text <- paste(ht, collapse = ",")
        lt_text <- paste(lt, collapse = ",")

        higher_than <- NULL
        lower_than <- NULL

        if(length(ht > 0)) higher_than <- paste("Higher than", ht_text, collapse = ",")
        if(length(lt > 0)) lower_than <- paste("Lower than", lt_text, collapse = ",")

        text <- str_c(higher_than, lower_than, sep = ". ")

        if (length(text) == 0) text <- ""

        test_result[i] <- text
    }

    return(test_result)

}

# function to produce a table with test results

make_test <- function(tab, conf) {

    s <- as.numeric(tab[1, 5:ncol(tab)])
    results <- matrix(NA, nrow(tab)-1, ncol(tab) - 4)

    suppressWarnings({
        for (row_i in 2:nrow(tab)) {
            results[row_i-1,] <-
                get_prop_test(
                    proportions = as.numeric(tab[row_i, 5:ncol(tab)]),
                    samples = s,
                    confidence = conf)
        }
    })

    test_results_tab <- tab
    test_results_tab[,4:ncol(tab)] <- NA
    test_results_tab[1,] <- NA
    test_results_tab[1,5:ncol(tab)] <- as.list(as.character(1:(ncol(tab)-4)))
    test_results_tab[1,3] <- "Column number"
    test_results_tab[2:nrow(tab),5:ncol(tab)] <- results

    return(test_results_tab)
}
