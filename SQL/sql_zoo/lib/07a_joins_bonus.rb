# == Schema Information
#
# Table name: albums
#
#  asin        :string       not null, primary key
#  title       :string
#  artist      :string
#  price       :float
#  rdate       :date
#  label       :string
#  rank        :integer
#
# Table name: styles
#
# album        :string       not null
# style        :string       not null
#
# Table name: tracks
# album        :string       not null
# disk         :integer      not null
# posn         :integer      not null
# song         :string

require_relative './sqlzoo.rb'

def alison_artist
  # Select the name of the artist who recorded the song 'Alison'.
  execute(<<-SQL)
    SELECT
      albums.artist
    FROM
      albums
    JOIN
      tracks ON tracks.album = albums.asin
    WHERE
      tracks.song = 'Alison'
  SQL
end

def exodus_artist
  # Select the name of the artist who recorded the song 'Exodus'.
  execute(<<-SQL)
    SELECT
      albums.artist
    FROM
      albums
    JOIN
      tracks ON tracks.album = albums.asin
    WHERE
      tracks.song = 'Exodus'
  SQL
end

def blur_songs
  # Select the `song` for each `track` on the album `Blur`.
  execute(<<-SQL)
    SELECT
      tracks.song
    FROM
      tracks
    JOIN
      albums ON albums.asin = tracks.album
    WHERE
      albums.title = 'Blur'
  SQL
end

def heart_tracks
  # For each album show the title and the total number of tracks containing
  # the word 'Heart' (albums with no such tracks need not be shown). Order first by
  # the number of such tracks, then by album title.
  execute(<<-SQL)
    SELECT
      DISTINCT albums.title,
      COUNT(tracks.song)
    FROM
      albums
    JOIN 
      tracks ON albums.asin = tracks.album
    WHERE
      tracks.song LIKE '%Heart%'
    GROUP BY
      albums.title
    ORDER BY
      COUNT(tracks.song) DESC, albums.title
  SQL
end

def title_tracks
  # A 'title track' has a `song` that is the same as its album's `title`. Select
  # the names of all the title tracks.
  execute(<<-SQL)
    SELECT
      albums.title
    FROM
      albums
    JOIN
      tracks ON tracks.album = albums.asin
    WHERE
      tracks.song = albums.title
  SQL
end

def eponymous_albums
  # An 'eponymous album' has a `title` that is the same as its recording
  # artist's name. Select the titles of all the eponymous albums.
  execute(<<-SQL)
    SELECT
      albums.title
    FROM
      albums
    JOIN
      albums AS arts ON arts.asin = albums.asin
    WHERE
      albums.title = arts.artist
  SQL
end

def song_title_counts
  # Select the song names that appear on more than two albums. Also select the
  # COUNT of times they show up.
  execute(<<-SQL)
    SELECT
      DISTINCT albums.song,
      COUNT(albums.song)
    FROM (
      SELECT
        song,
        album
      FROM
        tracks
      GROUP BY
        song,album
    ) AS albums
    GROUP BY
      albums.song
    HAVING
      COUNT(albums.song) > 2
  SQL
end

def best_value
  # A "good value" album is one where the price per track is less than 50
  # pence. Find the good value albums - show the title, the price and the number
  # of tracks.
  execute(<<-SQL)
    SELECT
      albums.title,
      albums.price,
      track_count
    FROM (
      SELECT
        a.asin,
        COUNT(a.*) AS track_count
      FROM
        albums AS a
      JOIN
        tracks ON tracks.album = a.asin
      GROUP BY
        a.asin
      HAVING
        a.price/COUNT(a.*) < 0.50 
    ) AS counts 
    INNER JOIN
      albums ON albums.asin = counts.asin
    WHERE
      albums.price < 50
  SQL
end

def top_track_counts
  # Wagner's Ring cycle has an imposing 173 tracks, Bing Crosby clocks up 101
  # tracks. List the top 10 albums. Select both the album title and the track
  # count, and order by both track count and title (descending).
  execute(<<-SQL)
    SELECT
      albums.title,
      track_count
    FROM 
      albums
    JOIN (
      SELECT
        a.asin,
        COUNT(a.*) AS track_count
      FROM
        albums AS a
      JOIN
        tracks ON tracks.album = a.asin
      GROUP BY
        a.asin
    ) AS counts ON counts.asin = albums.asin
    ORDER BY
      track_count DESC, albums.title DESC
    LIMIT(10)
  SQL
end

def rock_superstars
  # Select the artist who has recorded the most rock albums, as well as the
  # number of albums. HINT: use LIKE '%Rock%' in your query.
  execute(<<-SQL)
    SELECT
      artists.artist,
      album_count
    FROM (
      SELECT
        albums.artist,
        COUNT(albums.*) AS album_count
      FROM
        albums
      INNER JOIN
        styles ON styles.album = albums.asin
      WHERE 
        styles.style LIKE '%Rock'
      GROUP BY
        albums.artist
    ) AS artists
    ORDER BY
      album_count DESC
    LIMIT(1)
  SQL
end

def expensive_tastes
  # Select the five styles of music with the highest average price per track,
  # along with the price per track. One or more of each aggregate functions,
  # subqueries, and joins will be required.
  #
  # HINT: Start by getting the number of tracks per album. You can do this in a
  # subquery. Next, JOIN the styles table to this result and use aggregates to
  # determine the average price per track.
  execute(<<-SQL)
    SELECT
      DISTINCT styles.style,
      (SUM(album_track_counts.price)/SUM(album_track_counts.num_tracks))
    FROM 
      styles
    JOIN (
      SELECT 
        albums.*,
        COUNT(albums.*) AS num_tracks
      FROM
        albums
      JOIN
        tracks ON tracks.album = albums.asin
      WHERE
        albums.price IS NOT NULL
      GROUP BY
        albums.asin
    ) AS album_track_counts ON album_track_counts.asin = styles.album
    GROUP BY
      styles.style
    ORDER BY
      (SUM(album_track_counts.price)/SUM(album_track_counts.num_tracks)) DESC
    LIMIT(5)
  SQL
end
