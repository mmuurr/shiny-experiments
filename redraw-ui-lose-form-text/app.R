library(tidyverse)
library(shiny)

## Render a UI with a text input.
## Enter values into the text input (but no direct server-side listeners on that text input).
## Two action buttons.
## One "submits" the text input (i.e. there's a server-side reactive conductor/endpoint on the submit button that examines the text input value).
## One re-draws the UI, with a some novel text to force a redraw (i.e. cache-busting).
## (Test whether the cache-busting is needed, too.)


