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

NOTE: This extension parses the undocumented custom extensions to RSS
used in ReverbNation concert listing feeds. Thus, it could break at
any moment if ReverbNation decides to change its feed format.

TESTING NOTE: The tests for this extension require Jeremy McAnally's
gems `context` and `stump`.
