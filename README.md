# About

This is a program that demonstrates a threading bug in the 0.17.0
pre-release version of the Celluloid gem (currently `0.17.0.pre15`).
The bug is that the JVM thread count continues to climb until it
errors out and Sidekiq dies.  This happens when using Sidekiq and the
pre-release Celluloid gem with all the default setup, but can be
worked around by changing Celluloid to use Threaded tasks instead of
Fibered tasks.

# Usage

## Step 1: Install JRuby and then bundle

```
$ rvm install jruby
...
$ rvm use jruby
Using /home/me/.rvm/gems/jruby-1.7.19
$ gem install bundler
...
$ bundle
...
```

## Step 2: Launch the sidekiq server in a terminal

```
$ ./threadingbug.rb sidekiq
...
```

## Step 3: Trigger the test in another terminal

```
$ ./threadingbug.rb test
```

## Step 4: See the results in the sidekiq server terminal

```
...
Number of threads: 5047
```

## Step 5: ???

## Step 6: Profit

# Additional notes

* I have tried this with the version of JRuby we found the bug in, the
  latest version of JRuby, and JRuby 9000.... it happens in all
  versions

* The bug does not appear in GitHub HEAD of Celluloid

* The bug does not appear if you use Threaded tasks instead of Fibered
  (if you run `./threadingbug.rb sidekiq-threaded`, you will see a
  reasonable number of threads)
