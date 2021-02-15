class RemoveUnneededIndexes < ActiveRecord::Migration[6.0]
  def change
    remove_index :friendly_id_slugs, name: "index_friendly_id_slugs_on_slug_and_sluggable_type", column: [:slug, :sluggable_type]
    remove_index :group_solutions, name: "index_group_solutions_on_solution_id", column: :solution_id
    remove_index :industry_requests, name: "index_industry_requests_on_request_id", column: :request_id
    remove_index :industry_solutions, name: "index_industry_solutions_on_solution_id", column: :solution_id
    remove_index :occupation_requests, name: "index_occupation_requests_on_request_id", column: :request_id
    remove_index :occupation_solutions, name: "index_occupation_solutions_on_solution_id", column: :solution_id
    remove_index :taggings, name: "index_taggings_on_tag_id", column: :tag_id
    remove_index :taggings, name: "index_taggings_on_taggable_id", column: :taggable_id
    remove_index :taggings, name: "index_taggings_on_tagger_id", column: :tagger_id
  end
end
