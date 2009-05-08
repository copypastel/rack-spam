Rack::Spam
==========

Rack::Spam is a Rack middleware that checks POSTed comments for spam, and can then either block the request or tag the request as spam for the underlying web application to deal with.

Current Status
--------------

If you trust Akismet as your spam filter, feel free to give Rack::Spam a whirl. 

Adding filters for Defensio and/or Mollom is a good place to start for anyone that's looking to help. Look at lib/filter/akismet.rb for a reference.

Setup
-----

### Rackup file ###

Three configuration arguments are needed, with a fourth optional one:

* :domain : The domain for your site. This usually equates to the username used when querying a spam service like Akismet.
* :post_url : Rack::Spam assumes that you have a single URL for POSTing comments. Only incoming requests that have said URL as their destination are checked for spam.
* :services : The services argument is a hash with the services' name as keys, and their API key as values. If a request is tagged as spam by single service, it's considered spam by Rack::Spam. At the moment, only :akismet is a valid service key. 
* :mode : (optional) If set to :block, requests that are deemed spam by Rack::Spam are not forwarded to the web application.

Unless :mode is set to :block, a request that's deemed spam will have '&spam=1' added to its input string. Check Rack::Spam#call for details.

In your rackup file, you'll end up with something similar:

    use Rack::Spam, :domain => 'http://copypastel.com', 
                    :post_url => '/comments', 
                    :services => {:akismet => '12345'},
                    :mode => :block

### HTML Comment Form ###

For a request to be considered a comment, and thus be checked for spam, two conditions must be met:

* The request's destination must be the :post_url configured.
* The request must contain :username, :email, and :comment input fields.

Be sure to name your form fields appropiately, i.e.:

    <form method='POST' action='/comments'>
      <input type='text' name='username' />
      <input type='text' name='email' />
      <textarea name='comment' />
    </form>