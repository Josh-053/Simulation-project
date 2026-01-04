
```{r xpose_vpc}
#| echo: false
sim_all <- sim_all %>%
  group_by(regimen) %>%
  mutate(rep = ((ID - 1L) %/% N_id) + 1L) %>%
  ungroup()

# Observed (first replicate per regimen) and simulated datasets formatted for vpc
obs_df <- sim_all %>%
  filter(rep == 1L) %>%
  select(id = ID, time, dv = DV, regimen)

# All sims with a "sim" column indicating replicate index
sim_df <- sim_all %>%
  select(id = ID, time, dv = DV, regimen, sim = rep)

# Generate VPC stratified by regimen
vpc(
  obs       = obs_df,
  sim       = sim_df,
  stratify  = "regimen",
  obs_cols  = list(dv = "dv"),
  sim_cols  = list(dv = "dv", sim = "sim"),
  pi        = c(0.05, 0.95),
  ci        = c(0.025, 0.975),
  # disable binning (use raw time/independent variable instead of bins)
  bin       = FALSE,
  # style lines & ribbons
  vpc_theme = list(
    # percentile lines: make them solid
    pi_med  = list(linetype = "solid"),  # median line
    pi_l    = list(linetype = "solid"),  # lower percentile line (5th)
    pi_u    = list(linetype = "solid"),  # upper percentile line (95th)
    
    # shaded area around the median
    pi_med_area = list(fill = "red", alpha = 0.20),
    
    # shaded areas around the lower/upper percentiles
    pi_area = list(fill = "blue", alpha = 0.20)))

# Save to file
ggsave("xpose4_vpc_by_regimen.png", width = 10, height = 8, dpi = 300)
```


A visual predictive check plot was created using the simulated dependent variable (DV) plotted against time (Figure 2).

This section produces a Visual Predictive Check (VPC) for **all dosing regimens** using the *xpose4 toolchain* via the `{vpc}` package (which underpins VPCs in xpose). We treat the **first replicate (first `N_id` subjects)** as the observed dataset and overlay it against prediction intervals computed from **all replicates**.

![VPC plots by dosing regimen](xpose4_vpc_by_regimen.png)