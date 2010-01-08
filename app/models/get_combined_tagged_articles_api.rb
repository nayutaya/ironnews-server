
# 合成タグ設定済み記事取得API
class GetCombinedTaggedArticlesApi < ApiBase
  column :division_tag, :type => :text
  column :category_tag, :type => :text
  column :area_tag,     :type => :text
  column :page,         :type => :integer, :default =>  1
  column :per_page,     :type => :integer, :default => 10
end
