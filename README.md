pg_restore --verbose --clean --no-acl --no-owner -h localhost -U postgres -d dbscg_api_development latest.dump
http://localhost:3001/api/cards.json?q[title_cont]=Goku
http://localhost:3001/api/cards.json?q[color_matches_any][]=Red&q[color_matches_any][]=Blue

```
curl --include --request POST \
--header "application/x-www-form-urlencoded" \
--data-binary "grant_type=client_credentials&client_id=236ce72c-281e-403b-8f31-f4f59db72124&client_secret=495ffe87-22aa-4e02-9786-ac45a7abcae8" \
"https://api.tcgplayer.com/token"

{
    "access_token": "cF7kOoBQwTom5H4S1gVZX0KOC-16Pp1MKav2rXfSVphlD6M5zE0QCdCjPLa9x6ghXb_yu1gvZkw9NM5lq-qkMCVeNyjQTwTI9Hiug6zyTH7TzbZhcJzAp4E4nqYj2BihSVmFYoqxRGWgWAOkmyuaRPGdSFuiNBsAI8vOPPpIGeKqxxelQhOlpZljRGQVS3QHZ31VlRXAi5CmpU7MoKqMQ12lS6G2Y7isrHKAWxncOfWrJIrazBdc6R47ymI7x1_hYC1jSOS0nypQDWF3RbKSspXMS0YXcNYSYB4zHvmqhApBfLqZLsTQyCEiVIXaooZ1twyKKQ",
    "token_type": "bearer",
    "expires_in": 1209599,
    "userName": "236ce72c-281e-403b-8f31-f4f59db72124",
    ".issued": "Wed, 16 Dec 2020 15:56:14 GMT",
    ".expires": "Wed, 30 Dec 2020 15:56:14 GMT"
}
```

http://api.tcgplayer.com/{{version}}/catalog/products?categoryId=27&getExtendedFields=true
http://api.tcgplayer.com/{{version}}/catalog/groups?offset=0&limit=100&categoryId=27
http://api.tcgplayer.com/{{version}}/pricing/group/2473
http://api.tcgplayer.com/{{version}}/catalog/products/137360,137361?getExtendedFields=true