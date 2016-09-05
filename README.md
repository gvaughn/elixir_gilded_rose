GildedRose (An Exercise in Refactoring)
=======================================
In memory of Jim Weirich and the [Ruby version of this he
did.](https://github.com/jimweirich/gilded_rose_kata)

This is an Elixir version of the Gilded Rose Kata, found
[here](http://iamnotmyself.com/2011/02/13/refactor-this-the-gilded-rose-kata/).

This is a refactoring kata, so you will be starting with a legacy
code base.  To work the Kata, clone this git repository and checkout
the master branch. Read the description below for the "rules"
involving this kata.

NOTE: There are 3 failing tests on master on purpose. Those represent
the new conjured item type you are expected to add.

## Changes from the original

This Elixir version follows the original code very closely (and it pained me to write it), but has the
following changes:

* The original had no tests.  Since this is a refactoring kata, I felt
  the tests were important and provide a fairly complete test suite.
  Just delete the tests if you wish to "go it alone".

* The original used a hard coded set of "items", presumably for
  testing the code.  Since I added test suite, the hard coded values were
  not of much use.  I also changed the interface to accept a list of
  items as a parameter rather than a hard coded constant.

You can read
[the original kata article](http://iamnotmyself.com/2011/02/13/refactor-this-the-gilded-rose-kata/) for more details.

## Git Branches

* The [master](https://github.com/gvaughn/elixir_gilded_rose/tree/master) branch contains the starting point for the kata.

* The [gvaughn](https://github.com/gvaughn/elixir_gilded_rose/tree/gvaughn) branch is my first solution for this kata.

* The [gvaughn2](https://github.com/gvaughn/elixir_gilded_rose/tree/gvaughn2) is my 2nd attempt, which I like better.

* The [eksperimental](https://github.com/gvaughn/elixir_gilded_rose/tree/eksperimental) branch is our first community addition.

* The [aptinio](https://github.com/gvaughn/elixir_gilded_rose/tree/aptinio) is our 2nd community edition.

* If you'd like to submit a PR with your own solution, I'll give you a
  branch too!


# Original Description of the Gilded Rose

Hi and welcome to team Gilded Rose. As you know, we are a small inn
with a prime location in a prominent city ran by a friendly innkeeper
named Allison. We also buy and sell only the finest
goods. Unfortunately, our goods are constantly degrading in quality as
they approach their sell by date. We have a system in place that
updates our inventory for us. It was developed by a no-nonsense type
named Leeroy, who has moved on to new adventures. Your task is to add
the new feature to our system so that we can begin selling a new
category of items. First an introduction to our system:

- All items have a SellIn value which denotes the number of days we
  have to sell the item
- All items have a Quality value which denotes how valuable the item
  is
- At the end of each day our system lowers both values for every item

Pretty simple, right? Well this is where it gets interesting:

  - Once the sell by date has passed, Quality degrades twice as fast
  - The Quality of an item is never negative
  - "Aged Brie" actually increases in Quality the older it gets
  - The Quality of an item is never more than 50
  - "Sulfuras", being a legendary item, never has to be sold or
    decreases in Quality
  - "Backstage passes", like aged brie, increases in Quality as it's
    SellIn value approaches; Quality increases by 2 when there are 10
    days or less and by 3 when there are 5 days or less but Quality
    drops to 0 after the concert

We have recently signed a supplier of conjured items. This requires an update to our system:

- "Conjured" items degrade in Quality twice as fast as normal items

Feel free to make any changes to the UpdateQuality method and add any
new code as long as everything still works correctly. However, do not
alter the Item class or Items property as those belong to the goblin
in the corner who will insta-rage and one-shot you as he doesn't
believe in shared code ownership (you can make the UpdateQuality
method and Items property static if you like, we'll cover for
you). Your work needs to be completed by Friday, February 18, 2011
08:00:00 AM PST.

Just for clarification, an item can never have its Quality increase
above 50, however "Sulfuras" is a legendary item and as such its
Quality is 80 and it never alters.
