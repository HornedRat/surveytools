require(dplyr)
require(tidyr)
require(tibble)
require(rlang)
require(openxlsx)
require(gtools)
require(foreign)

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

#function to write and format data to an excel sheet

write_tab <- function(tabs, filename) {

    #tabs - a LIST of tables

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
    p <- prop.test(x = successes, n = samples, correct = F)$p.value

    greater <- NA

    if (p < (1-confidence)) {
        if (proportions[[1]] > proportions[[2]]) {
            greater <- 1
        } else if (proportions[[1]] < proportions[[2]]) {
            greater <- 2
        }
    }

    return(greater)

}

# function to produce a table with test results

make_test <- function(tab, conf) {

    s <- c(tab[[1, 5]], tab[[1, 6]])

    suppressWarnings({
        test_results <- apply(tab[2:nrow(tab),], 1, function(x) {
            get_prop_test(
                proportions = as.numeric(x[5:6]),
                samples = s,
                confidence = conf)
        })
    })

    a <- c(FALSE, grepl(1,test_results))
    b <- c(FALSE, grepl(2,test_results))

    test_results_tab <- tab
    test_results_tab[,4:6] <- NA

    test_results_tab[a,5] <- "X"
    test_results_tab[b,6] <- "X"

    return(test_results_tab)
}
