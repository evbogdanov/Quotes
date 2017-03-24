use Mojolicious::Lite;
use experimental 'signatures';

get '/quotes' => sub ($c) {
    my $json = {
        quotes => [{
            id     => 1,
            text   => 'Hello, World!',
            source => 'K&R'
        }, {
            id     => 2,
            text   => 'Talk is cheap. Show me the code.',
            source => 'Linus'
        }]
    };
    $c->render(json => $json);
};

app->start;
