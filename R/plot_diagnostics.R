#' Plotting function to be called by user
#'
#' These functions make some basic plots for the user
#'
#' @param fitted A fitted model object
#' @param type A plot type for ggplot, either "timing" or "scatter"
#' @param logspace whether to plot the space in log space, defaults to TRUE
#' @import ggplot2
#' @importFrom dplyr left_join
#' @export
plot_diagnostics <- function(fitted, type = "timing", logspace = TRUE) {

  # rebuild data frame
  df <- predict(fitted)

  # join in mean
  mus <- data.frame(
    years = unique(df$years),
    mu = fitted$sdreport$value[which(names(fitted$sdreport$value) == "mu")]
  )
  df <- left_join(df, mus)
  df$timing <- as.factor(ifelse(df$x < df$mu, "pre", "post"))

  if (type == "scatter") {
    if (logspace == TRUE) {
      if(fitted$data_list$family %in% c(2,3,5)) {
      g <- ggplot(df, aes(pred, log(y), fill = timing, col = timing)) +
        geom_point(alpha = 0.5) +
        facet_wrap(~years, scales = "free") +
        geom_abline(intercept = 0, slope = 1) +
        xlab("Ln predicted") +
        ylab("Ln obs")
      }
      if(fitted$data_list$family %in% c(1)) {
        g <- ggplot(df, aes(log(pred), log(y), fill = timing, col = timing)) +
          geom_point(alpha = 0.5) +
          facet_wrap(~years, scales = "free") +
          geom_abline(intercept = 0, slope = 1) +
          xlab("Ln predicted") +
          ylab("Ln obs")
      }
    } else {
      if(fitted$data_list$family %in% c(2,3,5)) {
      g <- ggplot(df, aes(exp(pred), y, fill = timing, col = timing)) +
        geom_point(alpha = 0.5) +
        facet_wrap(~years, scales = "free") +
        geom_abline(intercept = 0, slope = 1) +
        xlab("Ln predicted") +
        ylab("Ln obs")
      }
      if(fitted$data_list$family %in% c(1)) {
        g <- ggplot(df, aes(pred, y, fill = timing, col = timing)) +
          geom_point(alpha = 0.5) +
          facet_wrap(~years, scales = "free") +
          geom_abline(intercept = 0, slope = 1) +
          xlab("Predicted") +
          ylab("Obs")
      }
    }
  }
  if (type == "timing") {
    if (logspace == TRUE) {
      if(fitted$data_list$family %in% c(2,3,5)) {
      g <- ggplot(df, aes(x, pred, fill = timing, col = timing)) +
        facet_wrap(~years, scales = "free") +
        xlab("Calendar day") +
        ylab("Ln pred and obs") +
        geom_point(aes(x, log(y), fill = timing, col = timing), size = 1, alpha = 0.5) +
        geom_line(col = "black")
      }
      if(fitted$data_list$family %in% c(1)) {
        g <- ggplot(df, aes(x, log(pred), fill = timing, col = timing)) +
          facet_wrap(~years, scales = "free") +
          xlab("Calendar day") +
          ylab("Ln pred and obs") +
          geom_point(aes(x, log(y), fill = timing, col = timing), size = 1, alpha = 0.5) +
          geom_line(col = "black")
      }
    } else {
      if(fitted$data_list$family %in% c(2,3,5)) {
      g <- ggplot(df, aes(x, exp(pred), fill = timing, col = timing)) +
        facet_wrap(~years, scales = "free") +
        xlab("Calendar day") +
        ylab("Ln pred and obs") +
        geom_point(aes(x, y, fill = timing, col = timing), size = 1, alpha = 0.5) +
        geom_line(col = "black")
      }
      if(fitted$data_list$family %in% c(1)) {
        g <- ggplot(df, aes(x, pred, fill = timing, col = timing)) +
          facet_wrap(~years, scales = "free") +
          xlab("Calendar day") +
          ylab("Ln pred and obs") +
          geom_point(aes(x, y, fill = timing, col = timing), size = 1, alpha = 0.5) +
          geom_line(col = "black")
      }
    }
  }
  return(g)
}
