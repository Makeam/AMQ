
json.vote @vote, :id
json.rating @vote.votable.rating
json.votable_id @vote.votable_id
json.votable_type @vote.votable_type
json.vote_up @vote.weight == 1 ? true : false
json.answer_owner false