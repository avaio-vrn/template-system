1. fix in controllers
Admin::Panel -> Admin::Panel::Base

2. in layouts
content_tag :h1, yield(:h1) -> yield(:h1)

3. in all show
provide :h1 -> provide content_tag :h1
