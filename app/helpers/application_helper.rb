module ApplicationHelper
  def login_url
    "https://www.facebook.com/dialog/oauth?"
    + "client_id=383285121729602"
    + "&redirect_uri=YOUR_REDIRECT_URI"
    + "&scope=COMMA_SEPARATED_LIST_OF_PERMISSION_NAMES"
    + "&state=SOME_ARBITRARY_BUT_UNIQUE_STRING"
  end
end
