#!perl -T

use Test::More tests => 6;

my $class;
BEGIN {
    $class = 'JavaScript::Framework::jQuery'; 
	use_ok( $class );
}

my $jquery;


eval {
    $jquery = $class->new();
};
like($@, qr/\QAttribute (library) is required/, 'raise exception for empty argument list');

eval {
    $jquery = $class->new(
        library => 'flintstone',
    );
};
like($@,
    qr/\QAttribute (library) does not pass the type constraint because: Validation failed for 'JavaScript::Framework::jQuery::Subtypes::libraryAssets' failed with value flintstone/,
    'raise exception to violation of type constraint');

$jquery = $class->new(
    library => {
        src => [ 'js/jquery.min.js' ],
        css => [
            { href => 'theme/ui.all.css', media => 'screen' },
        ],
    }
);
isa_ok($jquery, $class);

eval {
    $jquery = $class->new(
        library => {
            src => [ 'js/jquery.min.js' ],
            css => [
                { href => 'theme/ui.all.css', media => 'screen' },
            ],
        },
        plugins => [
            {
                name => 'mcDonalds',
                library => {
                    src => [ '/js/jquery.mcdropdown.js', '/js/jquery.bgiframe.js' ],
                    css => [ { href => '/css/jquery.mcdropdown.css', media => 'all' } ],
                },
            },
        ],
    );
};
like($@,
    qr/\QUnknown plugin cannot be configured: JavaScript::Framework::jQuery::Plugin::mcDonalds/,
    'raise exception for non-existent plugin type');

$jquery = $class->new(
    library => {
        src => [ 'js/jquery.min.js' ],
        css => [
        { href => 'theme/ui.all.css', media => 'screen' },
        ],
    },
    plugins => [
        {
            name => 'mcDropdown',
            library => {
                src => [ '/js/jquery.mcdropdown.js', '/js/jquery.bgiframe.js' ],
                css => [ { href => '/css/jquery.mcdropdown.css', media => 'all' } ],
            },
        },
    ],
);
isa_ok($jquery, $class);

