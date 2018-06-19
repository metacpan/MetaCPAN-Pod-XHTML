use strict;
use warnings;
use Test::More;

use MetaCPAN::Pod::XHTML;

my $parser = MetaCPAN::Pod::XHTML->new;
$parser->output_string( \(my $output = '') );
my $pod = <<'END_POD';
  =head1 SYNOPSIS

      Foo
        Bar

      Guff

  =cut
END_POD
$pod =~ s/^  //mg;
$parser->parse_string_document("$pod");

like $output, qr{(?:>|^)Foo}m;
like $output, qr{(?:>|^)  Bar}m;
like $output, qr{(?:>|^)Guff}m;

$parser = MetaCPAN::Pod::XHTML->new;
$parser->output_string( \($output = '') );
$parser->strip_verbatim_indent(sub { undef });
$parser->parse_string_document("$pod");

like $output, qr{(?:>|^)    Foo}m;
like $output, qr{(?:>|^)      Bar}m;
like $output, qr{(?:>|^)    Guff}m;

$parser = MetaCPAN::Pod::XHTML->new;
$parser->output_string( \($output = '') );
$pod = <<'END_POD';
  =head1 SYNOPSIS

      Foo
      Bar	Bar
      Guff	Guff

  =cut
END_POD
$pod =~ s/^  //mg;
$parser->parse_string_document("$pod");

like $output, qr{(?:>|^)Foo}m;
like $output, qr{(?:>|^)Bar Bar}m;
like $output, qr{(?:>|^)Guff        Guff}m;

done_testing;
