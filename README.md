## solved MVP

This repo is not indicative of code readability / documentation as this was quickly coded to test the idea out. The RBS Calculator [repo](https://github.com/allyourbasepair/rbscalculator) is a better representation of my level of documentation.

### The problem

There are many feature-rich general SaaS software such as AirTable, ClickUp, monday.com, etc. that provide "building-blocks" for non-technical people to put together solutions to organise data better, create automated workflows, etc. that make them more productive.

Non-technical people, however, find it overwhelming to put together a solution / workflow to solve their problem using the software they find. 

They generally watch tutorial videos on YouTube to see how someone else has put together a workflow and then try to apply what they learn to their situation.
(The easiest way to learn to do something is to see how someone in your situation is solving the problem you face.)

### How does `solved` help with this?

`solved` is meant to be a video search site that allows you to easily find videos tutorials of how people in your industry / occupation apply SaaS apps to their situation to solve their problems.

You  can "follow" your industry / occupation (which is like a subreddit) and get updates via a newsletter of new solutions posted to your industry / occupation.

### [Demo](https://solvedapp.herokuapp.com/search/solutions)
Please note the demo is running on a free Heroku dyno so the site may take a few minutes to load if the dyno is sleeping.

## Screenshots

The site is fully responsive. This section only includes screenshots from the desktop version of the site.

#### Solution search page
Features: 
- search as you type
- ability to filter by price, industry / occupation, and product
![Solution search page](screenshots/solution_search.png?raw=true)


#### Industry / Occupation search page
Features: 
- search as you type
![Solution search page](screenshots/search_for_industry_or_occupation.png?raw=true)

#### Industry / Occupation page
Features: 
- ability to suggest keyword
- ability to follow (when logged in)

When logged out:
![When logged out](screenshots/industry_occupation_page.png?raw=true)

With description expanded:
![With description expanded](screenshots/industry_occupation_page_with_description.png?raw=true)

When logged in:
![When logged in](screenshots/industry_occupation_page_signed_in.png?raw=true)

#### Post a solution page
Features: 
- choose from previously added SaaS company or add a new company
- ability to post solution (and create account when not signed in)
![post_a_solution_1](screenshots/post_a_solution_1.png?raw=true)
![post_a_solution_2](screenshots/post_a_solution_2.png?raw=true)
![post_a_solution_3](screenshots/post_a_solution_3.png?raw=true)
