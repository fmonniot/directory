Fabricator(:visit) do
  session_id   '653e01a6f6bb2d866ea3c1dec69b65a2'
  method       'GET'
  url          'http://localhost:3000/api/people/search?q=ch&type=n&page=1'
  ip           '127.0.0.1'
  params       {{'q' => 'ch', 'type' => 'n', 'page' => '1', 'action' => 'search', 'controller' => 'api/people'}}
  http_headers {{'HTTP_HOST' => 'localhost:3000',
                 'HTTP_USER_AGENT' => 'Mozilla/5.0 (X11; Linux x86_64; rv:25.0) Gecko/20100101 Firefox/25.0',
                 'HTTP_ACCEPT' => 'application/json, text/plain, */*',
                 'HTTP_ACCEPT_LANGUAGE' => 'fr-fr,fr;q=0.8,en-us;q=0.5,en;q=0.3',
                 'HTTP_ACCEPT_ENCODING' => 'gzip, deflate',
                 'HTTP_DNT' => '1',
                 'HTTP_X_REQUESTED_WITH' => 'XMLHttpRequest',
                 'HTTP_REFERER' => 'http://localhost:3000/',
                 'HTTP_COOKIE' => 'Some cookies' }}
end
