#!/usr/bin/perl

##############################################################
# Extract SVN last changed information of this repository
##############################################################

##############################
# get svn information
##############################
my $ver=`LANG=C svn info`;
my @vars = split(/\n/, $ver);

##############################
# extract last changed info
##############################
my $str;
for my $v (@vars) {
    if ($v=~/^Last Changed/) {
        $v =~s/Last Changed//;
        $str .=$v;
    }
}
$str="Last Changed".$str;

##############################
# output svnrevision
##############################
open(VER_FILE,">.svnrevision");
print VER_FILE "$str\n";
close(VER_FILE);

