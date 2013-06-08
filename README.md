# ActsAsRrranking

[![Build Status](https://travis-ci.org/cctiger36/acts_as_rrranking.png?branch=master)](https://travis-ci.org/cctiger36/acts_as_rrranking) [![Gem Version](https://badge.fury.io/rb/acts_as_rrranking.png)](http://badge.fury.io/rb/acts_as_rrranking) [![Code Climate](https://codeclimate.com/github/cctiger36/acts_as_rrranking.png)](https://codeclimate.com/github/cctiger36/acts_as_rrranking)

A rails plugin use redis to sort models on real time.

## Example

    class Player < ActiveRecord::Base
      acts_as_rrranking :ranking, score: :game_point
    end

## Arguments

### name

the name of the ranking field

### options

<table>
  <tr>
    <td>score</td><td>the field which the models can be sorted by (default: :score)</td>
  <tr>
  </tr>
    <td>id</td><td>the identification field of the models (default: :id)</td>
  </tr>
</table>

## Helper Methods

Suppose the name is :ranking and the score field is :game_point then the following methods will be generated:

<table>
  <tr>
    <td>#current_ranking</td><td>return the current ranking</td>
  <tr>
  </tr>
    <td>#update_ranking(score)</td><td>update the score to redis, also will be invoked in the after_save hook</td>
  <tr>
  </tr>
    <td>::top_rankings(limit, offset)</td><td>return the array of top ids</td>
  <tr>
  </tr>
    <td>::top_ranking_player(limit, offset)</td><td>return the array of top models</td>
  </tr>
</table>
