# GourmentSearch
## API  
・ホットペッパーAPI  
空文字で投げるとStatus200でエラー情報が返ってきてデコードできないので  
空文字で検索クエリは投げないこと  
party_capacityは空の時String、そうでない時Intで返ってくるので  
デコード対象に入れないこと  
