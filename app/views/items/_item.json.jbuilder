json.extract! item, :id, :price, :description, :image_url, :category, :for_sale, :created_at, :updated_at
json.url item_url(item, format: :json)
