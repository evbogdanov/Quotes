use Mojolicious::Lite;
use experimental 'signatures';

get '/quotes' => sub ($c) {
    my $json = {
        quotes => [{
            text   => 'Hello, World!',
            source => 'K&R'
        }, {
            text   => 'Talk is cheap. Show me the code.',
            source => 'Linus Torvalds'
        }, {
            text   => 'Premature optimization is the root of all evil (or at least most of it) in programming.',
            source => 'Donald Knuth'
        }]
    };
    $c->render(json => $json);
};

app->start;
