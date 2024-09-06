library(tidyverse)
library(patchwork)

# ```{r}
# #| label: piping
# #| code-line-numbers: true
# #| eval: false
# 
# # non-piping
# f(g(h(my_data)))
# 
# # piping
# my_data |> 
#   h() |> 
#   g() |> 
#   f()
# ```

load("data/county_cwift_by_income.rda")
load("data/state_cwift_by_income.rda")


# CWIFT heat maps
(cwift_by_income_maps <-
(state_cwift_by_income + county_cwift_by_income) +
   plot_annotation(tag_levels = "A", tag_prefix = "(", tag_suffix = ")") +
   plot_layout(guides = "collect") &
   theme(
     legend.position = "bottom",
     plot.tag = element_text(size = 18)
   ))

ggsave(
  filename = "plots/cwift_by_income_maps.png",
  plot = cwift_by_income_maps,
  height= 3.5,
  width = 11,
  units = "in"
)
