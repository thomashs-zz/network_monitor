# Network Monitor

![Network Monitor](https://raw.githubusercontent.com/thomashs/network_monitor/master/screenshot.png)

This is a really simple network monitor build with Rails and a Ruby `SNMP` (Simple Network Management Protocol) library to get some network traffic information. It's your to play around / copy or distribute :)

# Installation

1. Make sure you have `ruby 1.9.3` installed. If you don't have, go ahead and install using [RVM](https://rvm.io/).
2. Download this source code and in the root application folder, run:

```ruby
bundle install
```

If you see any error messages, try to run this:

```ruby
gem install bundler
```

3. Migrate (create) the database:

```ruby
rake db:migrate
```

4. run your application and enjoy :)

```ruby
rails s
```

Not working? Google it.  
Can't find your answer on Google? [@thomashs](http://www.twitter.com)