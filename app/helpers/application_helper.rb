module ApplicationHelper
  def top_page
    link_to 'トップ', root_path, class: 'bg-gray-300 hover:bg-gray-400 text-gray-800 font-bold py-2 px-4 rounded-l ml-4'
  end
end
