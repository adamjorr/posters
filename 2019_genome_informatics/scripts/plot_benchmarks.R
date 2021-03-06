#!/usr/bin/env Rscript
library(tidyverse)

get_data_dir <- function(path){
  return(paste0("../data/", path))
}

get_benchmark_file <- function(stem){
  return(paste0(get_data_dir(stem),".benchmark"))
}

get_gatk_csv_file <- function(stem){
  return(paste0(get_data_dir(stem),".recal.after.csv"))
}

p_to_q <- function(p){
  return(floor(-10*log10(p)))
}

#returns a df with covariatevalue and reportedquality columns
average_over_rgs <- function(df){
  df %>%
    filter(CovariateName == 'QualityScore' & Recalibration == 'After') %>%
    rename(PredictedQuality = CovariateValue) %>%
    mutate_at(vars(FalseNegativeRate, PredictedQuality), as.numeric) %>%
    group_by(FalseNegativeRate, PredictedQuality) %>%
    summarize(ActualQuality = p_to_q(sum(Errors)/sum(Observations)))
}

import_fnr_csvs <- function(fnr){
  csv_files <- get_gatk_csv_file(fnr)
  dfs <- map(csv_files, read_csv)
  names(dfs) <- fnr
  df <- bind_rows(dfs, .id = 'FalseNegativeRate')
  return(df)
}

plot_fnr_csvs <- function(gatk_df){
  ggplot(gatk_df, aes(PredictedQuality, ActualQuality)) +
    geom_abline(slope = 1, intercept = 0) +
    geom_point(aes(color = factor(FalseNegativeRate)), size = 2) +
    geom_line(aes(color = factor(FalseNegativeRate)), size = 1) +
    scale_color_brewer('Known Sites\nFalse Negative\nRate', palette = 'PRGn') +
    scale_x_continuous("Predicted Quality") +
    scale_y_continuous("Actual Quality") +
    ggtitle('False Negative Variants Cause Underconfidence') +
    coord_fixed(ratio = 1) +
    theme_minimal(base_size = 18) + 
    theme(plot.margin = margin(0,0,0,0))
}

import_fnr_benchmarks <- function(fnr){
  benchmark_files <- get_benchmark_file(fnr)
  dfs <- map(benchmark_files, read_table2, col_names = c('PredictedQuality','ActualQuality','FalseNegativeRate','NumBases'))
  df <- bind_rows(dfs)
  return(df)
}

plot_comparison_dfs <- function(comparison_dfs){
  ggplot(comparison_dfs, aes(PredictedQuality, ActualQuality)) +
    geom_abline(slope = 1, intercept = 0) +
    geom_point(aes(color = CalibrationMethod), size = 2) +
    geom_line(aes(color = CalibrationMethod), size = 1) +
    scale_color_brewer('Calibration\nMethod', palette = 'Dark2') +
    scale_x_continuous("Predicted Quality") +
    scale_y_continuous('Actual Quality') +
    ggtitle('GATK and KBBQ Perform Similarly') +
    coord_fixed(ratio = 1) +
    theme_minimal(base_size = 18) +
    theme(plot.margin = margin(0,0,0,0))
}


fnr <- c(0, 20, 40, 60, 80, 100)
kbbq_benchmark_files <- get_benchmark_file(fnr)
gatk_csv_files <- get_gatk_csv_file(fnr)

gatk_df <- average_over_rgs(import_fnr_csvs(fnr))

pdf('../figures/generated/fnr.pdf', width = 9, height = 7)
plot_fnr_csvs(gatk_df)
dev.off()

# kbbq_df <- import_fnr_benchmarks(fnr)
kbbq_comparison_df <- get_gatk_csv_file('kbbq') %>%
  read_csv() %>%
  filter(CovariateName == 'QualityScore' & Recalibration == 'After')
gatk_comparison_df <- get_gatk_csv_file('0') %>%
  read_csv() %>%
  filter(CovariateName == 'QualityScore' & Recalibration == 'After')
raw_comparison_df <- get_gatk_csv_file('0') %>%
  read_csv() %>%
  filter(CovariateName == 'QualityScore' & Recalibration == 'Before')

comparison_dfs <- list( KBBQ = kbbq_comparison_df, GATK = gatk_comparison_df, Raw = raw_comparison_df)
comparison_df <- bind_rows(comparison_dfs, .id = 'CalibrationMethod') %>%
  rename(PredictedQuality = CovariateValue) %>%
  mutate(PredictedQuality = as.numeric(PredictedQuality)) %>%
  group_by(CalibrationMethod, PredictedQuality) %>%
  summarize(ActualQuality = p_to_q(sum(Errors)/sum(Observations)))

pdf('../figures/generated/comparison.pdf', width = 9, height = 7)
plot_comparison_dfs(comparison_df)
dev.off()







