#
# Copyright (c) 2009 Nokia Corporation and/or its subsidiary(-ies).
# All rights reserved.
# This component and the accompanying materials are made available
# under the terms of "Eclipse Public License v1.0"
# which accompanies this distribution, and is available
# at the URL "http://www.eclipse.org/legal/epl-v10.html".
#
# Initial Contributors:
# Nokia Corporation - initial contribution.
#
# Contributors:
#
# Description: 
#
# ============================================================================
#  Name     : loc_generator.pl
#  Part of  : create loc files to \epoc32\s60\locfiles base on subfolders in the same folder
#  Origin   : S60 build team,NMP
#  Created  : Tue Sep 24 11:32:47 2006
#  Version  : 0.2
#  Description:
#	 Version 0.2 changes(VL): added "dirty hack" so that new string is added for all layers, 
#	 this need to be removed when S60locfiles is exporting localized .loc files to correct layers !!!
#  Also added fix to sub routine update_locs [if ($key eq "") {next}; # skip empty ones]


use strict;
use File::Basename; # for fileparse
use Getopt::Long;
use Data::Dumper;		# debugging purposes

#
# Variables...
#
my $version = "0.2";
my $locfile_path;
my $loc_sc_folder = "sc";
my $loc_01_folder = "01";
my @generated_files;

my $input;
my $dozip;
my $noupdatelocfiles;
my $force_generation;
my $show_help;

my $result = GetOptions('i:s' => \$input, 'zip:s' => \$dozip, 'noUpdate' => \$noupdatelocfiles, 'force' => \$force_generation , 'h' => \$show_help);	

if ($show_help) {help(); die "";};

if ($input && (!-d $input)){&error_msg("Invalid parameter '$input'!");}
if ($input  && $input !~ m/\\$/) {$input .= "\\";};

if (!$result){&error_msg("Required Arguments are missing or wrong");}
#
# Hello text
#
hello();

# paths to exported loc files
my @exportedlocfilepaths = ("\\epoc32\\include\\platform\\loc", "\\epoc32\\include\\platform\\mw\\loc", "\\epoc32\\include\\platform\\app\\loc");

if ($input) {
	generate_locs($input);
	if ($dozip) {zipup_genfiles($input)};
}
foreach $locfile_path (@exportedlocfilepaths) {
	generate_locs($locfile_path);
}

sub zipup_genfiles {
	my $folder = shift;
	unlink($dozip);
	print "zip.exe -j -m $dozip @{generated_files}\n";
	system ("zip.exe -j -m $dozip @generated_files");
}

# generate switch loc files
sub generate_locs {
	my $folder = shift;
	my @files;
	my @languageids;
	@generated_files=();
	
# get language ids from folder names
# use sc as reference
	if (-d ${folder}.${loc_sc_folder}) {
    opendir(SDIR, ${folder}.${loc_sc_folder}) or &error_msg("can not read ${folder}${loc_sc_folder}\n");
	  @files = grep !/^\.\.?$/ && /.loc$/i, readdir SDIR;
	  closedir(SDIR);

	  opendir(SDIR, $folder) or &error_msg("can not read $folder\n");
	  @languageids = grep !/^\.\.?$/ && /^\d+?$/i, readdir SDIR;
	  closedir(SDIR);
	}
# get language ids from zip file names. 
# use 01 as reference
	elsif (-f "${folder}${loc_01_folder}.zip") {
		open ZIP, "unzip -Z1 ${folder}${loc_01_folder}.zip |";
		while (<ZIP>)
		{
			chomp;
			$_ =~ s/.*\///i;
			$_ =~ s/_${loc_01_folder}//i;
		
			push @files ,$_; 
		}
		close ZIP;
		
	  opendir(SDIR, $folder) or &error_msg("can not read $folder\n");
	  my @zipfiles = grep !/^\.\.?$/ && /^\d+?.zip$/i, readdir SDIR;
	  closedir(SDIR);
	  foreach (@zipfiles) {
	  	$_ =~ s/.zip//i;
	  	push @languageids, $_;
	  }
	}

#	print Dumper( @languageids );

	foreach my $loc_file (@files) {
		$loc_file =~ s/_${loc_01_folder}//i;
		if (!-e $folder.$loc_file || $force_generation) {
			push @generated_files, $folder.$loc_file."\n";
			create_include_loc($folder, $loc_file, \@languageids);
		}
		if (!$noupdatelocfiles) {
			update_locs($folder, $loc_file, \@languageids);
		}
	}
}

# update exist localized loc files base on exported original loc.
# create new files for all languages in case if loc is new one
# update new defines from component exported loc to exist localized files
sub update_locs {
	my $loc_path = shift;
	my $loc_file = shift;
	my $languageids = shift;
	my ($n, $ext) = split ('\.', $loc_file);

	if (!-f "${loc_path}${loc_sc_folder}\\${loc_file}"){return;};

	my %defines_orig = read_loc("${loc_path}${loc_sc_folder}\\${loc_file}");

	foreach my $languageID (@$languageids) {
		my @add;
		
		if (!-e "${loc_path}${languageID}\\${n}_${languageID}\.${ext}") {
			foreach my $key (keys %defines_orig) {
				push @add, $defines_orig{$key}."\n";
			}
		}
		else {
			my %defines = read_loc("${loc_path}${languageID}\\${n}_${languageID}\.${ext}");
			foreach my $key (keys %defines_orig) {
				if ($key eq "") {next}; # skip empty ones
				if (!exists $defines{$key}) {
					push @add, $defines_orig{$key}."\n";
				}
			}
			
		}		
		next if (!scalar @add);
		# Dirty quick hack to go trough all paths in this phase also 
		foreach my $locfile_path_temp (@exportedlocfilepaths) {
			if (!-f "${locfile_path_temp}${languageID}\\${n}_${languageID}\.${ext}"){next;};
			print "update ${locfile_path_temp}${languageID}\\${n}_${languageID}\.${ext} \n add lines\n @{add} \n";
			open (OUT_LOC,">>${locfile_path_temp}${languageID}\\${n}_${languageID}\.${ext}") or die "Cannot open ${locfile_path_temp}${languageID}\\${n}_${languageID}\.${ext} for reading: $!";
			print OUT_LOC "\n";
			print OUT_LOC @add;
			close OUT_LOC;
		}

	}
}

# read .loc file and return defined strings
sub read_loc {
	my $read_loc = shift;
	my %defines;
		
	open (IN,"$read_loc") or die "Cannot open ${read_loc} for reading: $!";
	my @lines=<IN>;
	close IN;
	
	my $open_comment = 0;
	foreach (@lines) {
		chomp;
    if (m!^\s*/\*!) {
	    $open_comment=1;
	    if (m!\*/!) {
	      $open_comment=0;
	    }
	    next;
    }
    if (m!\*/!) {
      $open_comment=0;
      next;
    }
    next if ($open_comment);
    next if (!m/^\s*?\#define/i);
		my $line = $_;

		$line =~ s/\"+/\"\#/;
    $_ =~ s/\s*?\#define\s+?//i;
    $_ =~ s/\s.*//i;
    
    $defines{$_}=$line;
	}
	
		return %defines;
}


# create switch loc file
sub create_include_loc {
	my $loc_path = shift;
	my $loc_file = shift;
	my $languageids = shift;

	my ($n, $ext) = split ('\.', $loc_file);
	print "create file ${loc_path}${loc_file}\n";
	open (OUT,">${loc_path}${loc_file}") or die "Cannot open ${loc_path}${loc_file} for writing: $!";

#	my $first = 1;
	print OUT "\#if LANGUAGE_${loc_sc_folder}\n";
	print OUT "\t\#include <${loc_sc_folder}\/${loc_file}\>\n";

	foreach my $languageID (@$languageids) {
#		next if (!-f "${locfile_path}\\${languageID}\\${n}_${languageID}${ext}");
#		if ($first) {
#			print OUT "\#if LANGUAGE_${languageID}\n";
#			$first = 0;
#		}
#		else {
			print OUT "\#elif LANGUAGE_${languageID}\n";
#		}
		print OUT "\t\#include <${languageID}\/${n}_${languageID}\.${ext}\>\n";
	}
	
#	print OUT "\#else\n";
#	print OUT "\t\#include <${loc_sc_folder}\\${loc_file}\>\n";
	print OUT "\#endif\n";


	close OUT;
}

sub datetime {
  my ($sec,$min,$hour,$day,$month,$year,$wbday,$yday,$isdst)=gmtime();
  $month++;
  $year+=1900;
  
  return (sprintf("%04d.%02d.%02d %02d:%02d:%02d",$year,$month,$day,$hour,$min,$sec));
}

sub hello {
  print "This is switch_loc_generator version ${version}\n";
  print "\n";
}

sub error_msg ($){
  my($ErrorMsg);
  ($ErrorMsg)=@_;
  my $given_command=$0;
  $given_command =~ s/.*\\(\w+\.\w+)$/$1/;
  print "";
  print "\n";
  print "Error: $ErrorMsg \n\n";
  help();
  die "\n";    
}

sub help {
  my $given_command=$0;
  $given_command =~ s/.*\\(\w+\.\w+)$/$1/;

  print "";
  print "\n";
  hello();
	print " Parameters:\n";
	print " -i <path to localized loc zips> : custom path to generated switch loc files. Option for localisation team\n";
	print " -zip <zip file name to zip up generated switch loc files> : path to zip up generated switch loc files. Option for localisation team\n";
	print " -noUpdate : do not update localised loc files in epoc32 -folder\n";
	print " -force : regenerate switch loc files even those are exists\n";
	print " -h : print this info message\n";
  print "Usage: \n$given_command -i <localised loc file folder>\n";
  print "Example:  \n$given_command -i \\s60\\misc\\release\\S60LocFiles\\data\n\n";
  print "Example for localization team:  \n$given_command -i ..\\data -zip ..\\data\\switch_loc.zip\n";
  print "\n";  
	
}