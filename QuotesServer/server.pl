use Mojolicious::Lite;
use experimental 'signatures';

my $identifier;

my @quotes = (
    {
        identifier => ++$identifier,
        text       => 'Hello, World!',
        source     => 'K&R'
    },
    {
        identifier => ++$identifier,
        text       => 'Talk is cheap. Show me the code.',
        source     => 'Linus Torvalds'
    },
    {
        identifier => ++$identifier,
        text       => 'Premature optimization is the root of all evil (or at least most of it) in programming.',
        source     => 'Donald Knuth'
    }
);

get '/quotes' => sub ($c) {
    $c->render(json => {quotes => \@quotes});
};

del '/quotes/:identifier' => sub ($c) {
    my $id = $c->param('identifier');
    
    my $count_before = scalar @quotes;
    @quotes = grep { $_->{identifier} != $id } @quotes;
    my $count_after = scalar @quotes;

    $c->render(json => {deleted => $count_before - $count_after});
};

post '/quotes' => sub ($c) {
    my $quote = {
        identifier => ++$identifier,
        text       => $c->param('text') // '...',
        source     => $c->param('source') // '...'
    };
    push @quotes, $quote;

    $c->render(json => {created => 1});
};

app->start;
