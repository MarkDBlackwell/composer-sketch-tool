=begin
Thirds Chords
Author: Mark D. Blackwell.
Date started writing: March 21, 2009.
Date last modified: May 7, 2009.
Copyright (c) 2009 Mark D. Blackwell.

G B Eb(D) F# A C# F(E) Ab C E(Eb) (D-F): Bb
With no notes found since, stop; report through last found.
Start with no gaps.
Then add 1 gap of 1 third in all positions,
2 gaps of 1 third.
Or, loop through chords.
No gaps, eleven thirds.
No duplicated notes.
0 0 1 0 0 1 0 0 1 0 0
1 1
1 0 0 1 0 1 0 0 1 0 0
0 1
1 1
0 0 1
1 0 1
0 1 1

G Ab A
0 1 2

All sequences of 11 minor and major thirds.
No more than two (2) major thirds in a row.
No more than three (3) minor thirds in a row.
(Avoid 12.)
0=minor, 1=major.
Stop if a note is duplicated and give the left-out notes.
11-bit binary numbers.
Are 2**11 = 2048 raw sequences.
Any permutation of 4's and 3's make 13 (minor ninth)?
Yes: G Bb C# E Ab = 3,3,3,4.
Any combination of 4 and 3 3's.
Also avoid 12.
Avoid the same notes.
Stop with all 12.
How to avoid infinite loop?
If at instruction comes to same note, not found.

generate_patterns
No gaps.
Eleven thirds.
No duplicated notes.
Loop through 2**11 chords
Keep good ones; reject bad ones.

require necklacechords
require thirdschords
require printer
require compositionfileio
namespace thirdschords
Use special processing for gaps; keep them out of chord_word.
Use Enumerable.
a = All_chords.new
a.each {|e| p e}
class gaps
Chord length not extended, only gaps intruduced.
If 11 thirds, then 10 places for gaps; excludes G.
Not shortening on the right, high-pitch, side.
Thus, not the last note, either, thus 9 places to put gaps.
Experience shows that 2-space gaps are the biggest found.
Minor thirds need not be accommodated --yes, they do, in order to cut different notes.
3-space gaps accommodate diminished chords, like G Bb C# E Ab becomes G _ _ _ Ab.
Experience shows 4 total spaces are the most meeded.
How many combinations are there of 4 drawn from 9 things?
Permutations of 9 is 9!; permutations of 4 is 4!.
Permutations of 4 drawn from 9 is 9!/(9-4)! = 9!/5!.
9 first choices, ... 6 fourth choices.
Number of permutations of these 4 is 4!, so, to get the number of combinations of these 4, divide by 4!.
So, 9!/(5!x4!) = 9x8x7x6/(4x3x2) = 3x7x6 = 9x2x7 = 2x3**2x7 =2x63 = 126.
Combinations of 5 drawn from 9 is 9!/((9-5)!x5!), also 126.
Of 6, 9!/((9-6)!x6!) = 9x8x7/(3x2) = 3x4x7 =84.
Need all from none up through 5.
Might as well do 512, removing ones that have too many spaces or too long stretches of gap.
Shift a bit word, looking for 4-space gaps (=15) and for more than 4 total 1-bits.
Generate gap words (10 bits = thirds_length - 1).
Shift through, checking 4-bit groupings and 1-bits.
Keep the good ones.
Keep and apply to all the thirds-length (=11) chords.

Processing one from each length, counted:
sorted_beginnings.collect {|e| e.length} [1, 2, 7, 26, 29, 13, 1]
gap_patterns.length 351
beginning [0]
diff 2931732
gap_patterns.length 198
beginning [0, 5]
diff 520313
gap_patterns.length 107
beginning [0, 10, 15]
diff 118281
gap_patterns.length 56
beginning [0, 11, 13, 15]
diff 27448
gap_patterns.length 29
beginning [0, 9, 11, 19, 20]
diff 2770
gap_patterns.length 15
beginning [0, 9, 11, 19, 20, 22]
diff 1364
gap_patterns.length 8
beginning [0, 7, 9, 11, 15, 20, 22]
diff 316
Chord.detail_count 3602224

extensions.length 718848
categorized_beginnings.collect {|a| a.length} [1, 2, 7, 26, 29, 13, 1]
@beginnings.first.length 1
extension_lengths 11
@@extension_categories.collect {|a| a.length} [0, 0, 0, 0, 590, 2753, 3255, 2368, 1093, 315, 42]
@@extension_categories.collect {|a| a.length} [0, 0, 0, 106, 964, 1681, 1684, 1041, 399, 74]
@@extension_categories.collect {|a| a.length} [0, 0, 27, 300, 763, 984, 741, 348, 70]
@@extension_categories.collect {|a| a.length} [0, 1, 44, 244, 471, 462, 291, 70]
@@extension_categories.collect {|a| a.length} [0, 4, 48, 175, 228, 179, 72]
@@extension_categories.collect {|a| a.length} [0, 3, 48, 94, 93, 42]
@@extension_categories.collect {|a| a.length} [0, 11, 37, 48, 24]
@@categorized_extensions.collect {|a| a.length} [12800, 51616, 89792, 118584, 131988, 166738, 101012, 37342, 8020, 914, 42]
#-----------------------------
CANDIDATE_INTERVALS (1..11).to_a
MINIMUM_GAP_INTERVAL 3
MAX_GAPS 3
MAX_HIGHEST_NOTE 10
nog count
0 232
1 568
2 216
3 8
all 1024
439 node.dump "nog: 3 i: [0,1,3,3,3] hn: 10"
823 node.dump "nog: 3 i: [0,3,1,3,3] hn: 10"
871 node.dump "nog: 3 i: [0,3,3,1,3] hn: 10"
877 node.dump "nog: 3 i: [0,3,3,3,1] hn: 10"
878 node.dump "nog: 3 i: [0,3,3,3] hn: 9"
879 node.dump "nog: 3 i: [0,3,3,4] hn: 10"
887 node.dump "nog: 3 i: [0,3,4,3] hn: 10"
951 node.dump "nog: 3 i: [0,4,3,3] hn: 10"

CANDIDATE_INTERVALS [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
MINIMUM_GAP_INTERVAL 9
MAX_HIGHEST_NOTE 24
MAX_GAPS 2
MAX_MINOR_SECOND 0
MAX_MINOR_NINTH 0
@@count 2324

CANDIDATE_INTERVALS [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
MINIMUM_GAP_INTERVAL 9
MAX_HIGHEST_NOTE 36
MAX_GAPS 2
MAX_MINOR_SECOND 0
MAX_MINOR_NINTH 0
@@count 58181

CANDIDATE_INTERVALS [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
MINIMUM_GAP_INTERVAL 9
MAX_HIGHEST_NOTE 48
MAX_GAPS 2
MAX_MINOR_SECOND 0
MAX_MINOR_NINTH 0
@@count 530446

CANDIDATE_INTERVALS [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
MINIMUM_GAP_INTERVAL 10
MAX_HIGHEST_NOTE 24
MAX_GAPS 2
MAX_MINOR_SECOND 0
MAX_MINOR_NINTH 0
@@count 2324

CANDIDATE_INTERVALS [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
MINIMUM_GAP_INTERVAL 10
MAX_HIGHEST_NOTE 36
MAX_GAPS 2
MAX_MINOR_SECOND 0
MAX_MINOR_NINTH 0
@@count 58425
-----------------Major rewrite
CANDIDATE_INTERVALS [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 14, 25, 26]
MINIMUM_GAP_INTERVAL 6
MAX_HIGHEST_NOTE 35
MAX_GAPS 3
MAX_MINOR_SECOND 0
MAX_MINOR_NINTH 0
@@count 65597
empty_ones.length  0
@fill_chords.length 2048
sum_length 2048
sum_length.to_f/@fill_chords.length  1.0
sum  2048

CANDIDATE_INTERVALS [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 14, 25, 26]
MINIMUM_GAP_INTERVAL 6
MAX_HIGHEST_NOTE 35
MAX_GAPS 3
MAX_MINOR_SECOND 0
MAX_MINOR_NINTH 0
@@count 65597
empty_ones.length  0
@fill_chords.length 2048
sum_length 65597
sum_length.to_f/@fill_chords.length  32.02978515625
sum  65597

@@candidate_intervals [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 13, 14, 25, 26]
@@minimum_gap_interval 6
@@max_gaps 3
@@max_minor_secondths 0
@@max_minor_ninths 1
@@max_highest_note 44
@@max_major_seconds_cluster 2
@@count 953771
empty_ones.length  0
@fill_chords.length 2048
sum_length 953771
sum_length.to_f/@fill_chords.length  465.70849609375
sum  953771
went to 404 Mb;
made 6697 chords for the last necklace.

@@candidate_intervals [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 13, 14, 25, 26]
@@minimum_gap_interval 6
@@max_gaps 3
@@max_minor_secondths 0
@@max_minor_ninths 1
@@max_highest_note 24
@@max_major_seconds_cluster 2
@@count 7352
empty_ones.length  759
@fill_chords.length 2048
sum_length 3756
sum_length.to_f/@fill_chords.length  1.833984375
sum  3756

@@candidate_intervals [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 13, 14, 25, 26]
@@minimum_gap_interval 6
@@max_gaps 3
@@max_minor_secondths 0
@@max_minor_ninths 1
@@max_highest_note 30
@@max_major_seconds_cluster 2
@@count 49533
empty_ones.length  64
@fill_chords.length 2048
sum_length 10058
sum_length.to_f/@fill_chords.length  4.9111328125
sum  10058

@most_significant_bit_value.to_s( 2) "100000000000"
@@candidate_intervals [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 13, 14, 25, 26]
@@minimum_gap_interval 6
@@max_gaps 3
@@max_minor_secondths 0
@@max_minor_ninths 1
@@max_highest_note 24
@@max_major_seconds_cluster 2
@@count 7352
empty_ones.length  759
@fill_chords.length 2048
sum_length 1289
sum_length.to_f/@fill_chords.length  0.62939453125
sum  1289

@most_significant_bit_value.to_s( 2) "100000000000"
@@candidate_intervals [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 13, 14, 25, 26]
@@minimum_gap_interval 6
@@max_gaps 3
@@max_minor_secondths 0
@@max_minor_ninths 1
@@max_highest_note 30
@@max_major_seconds_cluster 2
@@count 49533
empty_ones.length  64
@fill_chords.length 2048
sum_length 1984
sum_length.to_f/@fill_chords.length  0.96875
sum  1984

@most_significant_bit_value.to_s( 2) "100000000000"
@@candidate_intervals [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 13, 14, 25, 26]
@@minimum_gap_interval 6
@@max_gaps 3
@@max_minor_secondths 0
@@max_minor_ninths 1
@@max_highest_note 35
@@max_major_seconds_cluster 2
@@count 182239
empty_ones.length  0
@fill_chords.length 2048
sum_length 2048
sum_length.to_f/@fill_chords.length  1.0
sum  2048

@most_significant_bit_value.to_s( 2) "100000000000"
@@candidate_intervals [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 13, 14, 25, 26]
@@minimum_gap_interval 6
@@max_gaps 3
@@max_minor_secondths 0
@@max_minor_ninths 1
@@max_highest_note 35
@@max_major_seconds_cluster 2
@@count 182239
empty_ones.length  0
@fill_chords.length 2048
sum_length 2048
sum_length.to_f/@fill_chords.length  1.0
sum  2048

@most_significant_bit_value.to_s( 2) "100000000000"
@@candidate_intervals [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 13, 14, 25, 26]
@@minimum_gap_interval 6
@@max_gaps 3
@@max_minor_secondths 0
@@max_minor_ninths 1
@@max_highest_note 39
@@max_major_seconds_cluster 2
@@count 377055
empty_ones.length  0
@fill_chords.length 2048
sum_length 2048
sum_length.to_f/@fill_chords.length  1.0
sum  2048

@most_significant_bit_value.to_s( 2) "100000000000"
@@candidate_intervals [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 13, 14, 25, 26]
@@minimum_gap_interval 6
@@max_gaps 3
@@max_minor_secondths 0
@@max_minor_ninths 1
@@max_highest_note 24
@@max_major_seconds_cluster 2
@@count 7352
empty_ones.length  759
@fill_chords.length 2048
sum_length 1289
sum_length.to_f/@fill_chords.length  0.62939453125
sum  1289

@most_significant_bit_value.to_s( 2) "100000000000"
@@candidate_intervals [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 13, 14, 25, 26]
@@minimum_gap_interval 6
@@max_gaps 3
@@max_minor_secondths 0
@@max_minor_ninths 1
@@max_highest_note 24
@@max_major_seconds_cluster 2
@@count 7352
empty_ones.length  759
@fill_chords.length 2048
sum_length 1289
sum_length.to_f/@fill_chords.length  0.62939453125
sum  1289

@most_significant_bit_value.to_s( 2) "100000000000"
@@candidate_intervals [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 13, 14, 25, 26]
@@minimum_gap_interval 6
@@max_gaps 3
@@max_minor_secondths 0
@@max_minor_ninths 1
@@max_highest_note 35
@@max_major_seconds_cluster 2
@@count 182239
empty_ones.length  0
@fill_chords.length 2048
sum_length 2048
sum_length.to_f/@fill_chords.length  1.0
sum  2048

@most_significant_bit_value.to_s( 2) "100000000000"
@@candidate_intervals [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 13, 14, 25, 26]
@@minimum_gap_interval 6
@@max_gaps 3
@@max_minor_secondths 0
@@max_minor_ninths 1
@@max_highest_note 24
@@max_major_seconds_cluster 2
@@count 7352
empty_ones.length  759
@fill_chords.length 2048
sum_length 1289
sum_length.to_f/@fill_chords.length  0.62939453125
sum  1289
=end
require 'main'
Main::Program.new( note_space_width = 12).run
