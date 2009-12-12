#!perl -T

use Test::More tests => 7;

my $class;
BEGIN {
    $class = 'JavaScript::Framework::jQuery'; 
	use_ok( $class );
}

my $jquery;


$jquery = $class->new(
    xhtml => 1,
    library => {
        src => [ 'jquery.min.js' ],
        css => [ { href => 'ui.all.css', media => 'screen' } ],
    },
    plugins => [
        {
            name => 'mcDropdown',
            library => {
                src => [ 'jquery.mcdropdown.js', 'jquery.bgiframe.js' ],
                css => [ { href => 'jquery.mcdropdown.css', media => 'all' } ],
            },
        },
    ],
);
isa_ok($jquery, $class);

$jquery->construct_plugin(
    name => 'mcDropdown',
    target_selector => '#inputid',
    source_ul => '#ulid',
);

my $expected = '<link type="text/css" href="ui.all.css" rel="stylesheet" media="screen" />
<link type="text/css" href="jquery.mcdropdown.css" rel="stylesheet" media="all" />';
is($jquery->link_elements, $expected, 'output expected LINK elements');

$expected = '<script type="text/javascript" src="jquery.min.js"></script>
<script type="text/javascript" src="jquery.mcdropdown.js"></script>
<script type="text/javascript" src="jquery.bgiframe.js"></script>';
is($jquery->script_src_elements, $expected, 'output expected SCRIPT (with SRC attr) elements');

# add CDATA wrapper, since we want XHTML
$expected = <<'EOF';
<script type="text/javascript">
//<![CDATA[
$(document).ready(function (){
$("#inputid").mcDropdown("#ulid");
});
//]]>
</script>
EOF
chomp $expected;
is($jquery->document_ready, $expected, 'output jQuery $(document).ready(...)');

# add another option
$jquery->construct_plugin(
    name => 'mcDropdown',
    target_selector => '#input2id',
    source_ul => '#ulid2',
);
$expected = <<'EOF';
<script type="text/javascript">
//<![CDATA[
$(document).ready(function (){
$("#input2id").mcDropdown("#ulid2");
});
//]]>
</script>
EOF
chomp $expected;
is($jquery->document_ready, $expected, 'output jQuery $(document).ready(...)');

# multiple plugin objects in one request
$jquery->config_plugin(
    name => 'Superfish',
    library => {
        src => [ 'jquery.superfish.js', 'jquery.supersubs.js' ],
        css => [ { href => 'superfish.css', media => 'all' } ],
    },
);
$jquery->construct_plugin(
    name => 'mcDropdown',
    target_selector => '#input2id',
    source_ul => '#ulid2',
);
$jquery->construct_plugin(
    name => 'Superfish',
    target_selector => '#ulid',
    use_supersubs => 1,
);
$expected = <<'EOF';
<script type="text/javascript">
//<![CDATA[
$(document).ready(function (){
$("#input2id").mcDropdown("#ulid2");
$("#ulid").supersubs().superfish();
});
//]]>
</script>
EOF
chomp $expected;
is($jquery->document_ready, $expected, 'output jQuery $(document).ready(...)');

