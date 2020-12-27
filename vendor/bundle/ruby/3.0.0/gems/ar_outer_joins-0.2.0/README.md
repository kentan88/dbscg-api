# ActiveRecord Outer Joins

This gem adds support for the missing `.outer_joins` method. For the most part
it behaves exactly the same as `.joins`, except that it creates an outer join
instead of an inner join. If you don't know why that would be useful, this gem
is probably not for you.

## Installation

``` ruby
gem "ar_outer_joins"
```

## Usage

``` ruby
require "active_record"
require "ar_outer_joins"

class Product
  belongs_to :category

  def self.published
    outer_joins(:category).where("categories.published = ? OR products.published = ?", true, true)
  end
end
```

# License

(The MIT License)

Copyright (c) 2012 Jonas Nicklas, Elabs AB

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
