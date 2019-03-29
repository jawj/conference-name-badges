# Conference name badges

<img src="examples-6@2x.png" alt="6-up example badges" width="310" style="float: right; margin: 0 0 20px 20px" />

This page gives a quick walkthrough of how we made name badges for the [Royal Economic Society Annual Conference](https://www.res.org.uk/event-listing/annual-conference.html) in 2018. 


## Aims

We decided to design and print the name badges locally. This was in order to: 

1. reduce costs;
2. push back the deadline for finalising the delegate list; and
3. meet some specific design goals. 

The design goals were that the badges should: 

1. be reasonably attractive;
2. make clear which days delegates were registered for — or otherwise show that they had a special role, such as conference assistant; and
3. keep the delegate's name visible at all times, by double-siding.

We chose plain blue single-clip lanyards with 110×105mm T3 landscape PVC wallets (from [Lanyards Direct](https://www.lanyardsdirect.co.uk/product/plain-lanyards/plain-blue-lanyards/)). This was one of the cheapest options. The wallet dimensions were generous. They also let us fit 6 badges on a sheet with no wastage (or extra cutting).

Printed on 160gsm card and cut to size, the badges ended up looking like this:

<img src="example-printed@2x.jpg" alt="Finished example badge" width="400" height="483" />

## Creating badges in InDesign using Data Merge

Adobe has good [documentation on the Data Merge features of InDesign](https://helpx.adobe.com/indesign/using/data-merge.html), which I won't repeat here. 

Our [template document](name-badges-template.indd) (with the Data Merge tab open) looked like this:

<img src="template@2x.png" alt="InDesign template" width="526" height="365" />

We used **text data fields** for name (George MacKerron), affiliation (University of Sussex), and position (LOCAL ORGANISER). 

We used **image fields** referencing Illustrator files for a [blue 'Conference Assistant'](ConfAsst.ai) stamp and for the day indicators. The day indicators comprised of three placeholders, each of which could reference an empty circle or a filled circle showing one of the conference days (we therefore had 6 files in all: [MonY.ai](MonY.ai), [MonN.ai](MonN.ai), [TueY.ai](TueY.ai), [TueN.ai](TueN.ai), [WedY.ai](WedY.ai), [WedN.ai](WedN.ai)).

(We also had small [gold dots](GoldDot.ai) indicating that the delegate had registered for the conference dinner, and small [silver dots](SilverDot.ai) indicating that the delegate had special dietary requirements, but for simplicity I won't mention these again).

We set the Data Merge options to produce multiple records per page, and to lay those out row first.

<img src="multiple-records@2x.png" alt="Multiple records settings" width="401" height="157" />

<img src="layout-of-records@2x.png" alt="Record layout settings" width="367" height="79" />

We then merged the delegate [data](delegates-data.txt), which looked like this:

<img src="data@2x.png" alt="Example data" width="797" height="155" />

This produced sheets of badges ready for printing, 6 to an A4 page, which looked like this:

<img src="examples-6@2x.png" alt="6-up example badges" width="620" height="877" />

## Making the badges double-sided

At any given conference, [about half the people are walking around with their badge facing backwards so that no one can see their name](https://www.mattcutts.com/blog/ideal-conference-badge/).

One way to fix this is to buy double-clip lanyards. These fix to the badge at two corners, and keep it facing the right way. However, the price premium on these lanyards is pretty steep.

A nice alternative is to print the badge the same on both sides. 

But this isn't entirely simple. If we simply duplicate each set of 6 rows in the delegate data table, do the data merge, and then print the resulting sheets double-sided, the wrong badges end up back to back (on the top row in our above example, Cho Chang's badge will have Cornelius Fudge's details on the reverse and vice versa). 

What we need to is to duplicate each set of 6 rows and, _in addition_, switch each adjacent pair in the duplicated set.

That is, following the header row (1), we want to keep rows 2, 3, 4, 5, 6, 7 and then insert duplicates of those rows in the order 3, 2, 5, 4, 7, 6. And then repeat that process for each subsequent set of 6 rows.

That looks like this:

<img src="data-doubled@2x.png" alt="Correctly doubled-up example data" width="797" height="263" />

Obviously this would be tedious and error-prone to do by hand, so I wrote a [short Ruby script](double-six.rb) to take in the raw tab-separated data file and spit out a new data file with right pattern of duplicate rows.

On Mac or Linux, you can run this from Terminal by redirecting input and output data as follows:

    < delegates-data.txt ./double-six.rb > delegates-doubled.txt

The output file is then ready to use as the source for your Data Merge.

## Cut the badges in batches while maintaining alphabetical order

We had around 750 badges to produce. Using a guillotine, we found it was efficient to cut in batches of three sheets (18 badges) at a time.

We cut as follows. Taking three sheets together, we cut lengthways to make two columns, and stacked the left column on top of the right column. We then cut each column in three, leaving us with three stacks of six badges each. These were stacked in the same order they had appeared on the sheets — i.e. badges from the top row on top, badges from the middle row in the middle, and badges from the bottom row on the bottom.

You may think I have laboured this explanation a bit. But by following a single, consistent cutting order, we were able to make an optimisation prior to the merge. We re-ordered the rows of the delegate data so that, after we had cut the badges in these batches of 18, they would be in alphabetical order with no further sorting.

To make this work, badges 1, 2 and 3 must be at the _top left_ of sheets 1, 2 and 3 respectively. Badges 4, 5 and 6 should be at the _top right_ of sheets 1, 2 and 3. Then badges 7, 8 and 9 must be at _mid left_ of sheets 1, 2 and 3 ... and so on.

Once again I wrote [a short Ruby script](cutting-order.rb) to automate the necessary shuffle. This can be combined with the double-siding procedure above, but the shuffle must be done **first**.

This procedure assumes that your original delegate data is in the same order you want the cards to come out in, of course.

On Mac or Linux, you can run this from Terminal as follows:

    < delegates-data.txt ./cutting-order.rb 3 6 | ./double-six.rb > delegates-presorted-doubled.txt

The output file is then ready to use as the source for your Data Merge.

