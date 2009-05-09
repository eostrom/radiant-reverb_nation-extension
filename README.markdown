ReverbNation Extension
======================

Integrates concert listings from ReverbNation.com.

Sample (listing 5 shows for the artist with username 'tincat'):

    <h3>Upcoming</h3>
    <r:reverbnation id="tincat" country="US">
      <ul>
        <r:shows:each limit="5">
          <li><strong><r:date /></strong>, <r:venue />, <r:location /></li>
        </r:shows:each>
      </ul>
      <a href="<r:shows:url />">More info...</a>
    </r:reverbnation>

By default, the `location` tag includes city, state, and country
code. Specifying a default country in the `reverbnation` tag causes
that country code to be suppressed.

Listings for a given artist are cached for one hour, to prevent
excessive traffic to ReverbNation.

NOTE: This extension parses the undocumented custom extensions to RSS
used in ReverbNation concert listing feeds. Thus, it could break at
any moment if ReverbNation decides to change its feed format.

DEPENDENCIES: This extension uses the `FeedTools` gem to fetch and
cache RSS feeds from ReverbNation. Jeremy McAnally's gems `context`
and `stump` are required to run the tests, but not to use the
extension.
