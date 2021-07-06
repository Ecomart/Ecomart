final Map<String, dynamic> environmentMock = {
  'kAppConfig': 'lib/config/config_en.json',
  'serverConfig': {
    'type': 'woo',
    'url': 'https://mstore.io',
    'consumerKey': 'mock',
    'consumerSecret': 'mock',
    'blog':
        'https://mstore.io', //Your website woocommerce. You can remove this line if it same url
    /// remove to use as native screen
    'forgetPassword': 'https://mstore.io/wp-login.php?action=lostpassword'
  }
};
