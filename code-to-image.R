```{r}
#| label: piping
#| code-line-numbers: true
#| eval: false

# non-piping
f(g(h(my_data)))

# piping
my_data |> 
  h() |> 
  g() |> 
  f()
```