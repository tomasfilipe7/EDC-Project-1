module namespace funcs = "com.funcs.catalog";

declare function funcs:top-movies() {
  <movies>{(
  for $a in doc("movieDB/movies.xml")//movie
  order by $a/vote_average/text()/xs:double(.) descending
  return (
    <movie>{
      $a/original_title,
      $a/poster_path,
      $a/popularity,
      $a/vote_average,
      $a/id,
      for $c in $a/genres/item
      return $c/name
    }</movie>
  ))[position() < 11]
  }</movies>
};
declare function funcs:top-series() {
  <series>{(
  for $a in doc("movieDB/series.xml")//serie
  order by $a/vote_average/text()/xs:double(.) descending
  return (
    <serie>{
      $a/original_name,
      $a/poster_path,
      $a/popularity,
      $a/vote_average,
      $a/id,
      for $c in $a/genres/item
      return $c/name
    }</serie>
  ))[position() < 11]
  }</series>
};
declare function funcs:get-mgenres() {
  <genres>{
  let $a := doc("movieDB/movies.xml")//movie
  for $b in distinct-values($a/genres/item/name)
  order by $b
  return <genre>{$b}</genre>
  }</genres>
};
declare function funcs:get-sgenres() {
  <genres>{
  let $a := doc("movieDB/series.xml")//serie
  for $b in distinct-values($a/genres/item/name)
  order by $b
  return <genre>{$b}</genre>
  }</genres>
};
declare function funcs:get-genre-movies($g) {
  <movies>{
  for $a in doc("movieDB/movies.xml")//movie
  where ((for $g_item in $g return $g_item = $a/genres/item/name) = true())
  return $a
  }</movies>
};

declare function funcs:get-genre-series($g) {
  <series>{
  for $a in doc("movieDB/series.xml")//serie
  where ((for $g_item in $g return $g_item = $a/genres/item/name) = true())
  return $a
  }</series>
};

declare function funcs:get-search-movies($s) {
   <movies>{
        for $m in doc("movieDB/movies.xml")//movie
        where contains(lower-case($m/original_title), lower-case($s))
        return $m
   }</movies>
};
declare function funcs:get-search-series($s) {
   <series>{
        for $m in doc("movieDB/series.xml")//serie
        where contains(lower-case($m/name), lower-case($s))
        return $m
   }</series>
};
declare function funcs:get-search-persons($s) {
   <items>{
        for $mid in doc("movieDB/casts.xml")//cast
        where $mid/cast/item/original_name = $s
        return (
        for $a in doc("movieDB/movies.xml")//movie
          where $a/id = $mid/id
          return $a
        ),
        for $mid in doc("movieDB/casts.xml")//cast
        where $mid/crew/item/original_name = $s
        return (
        for $a in doc("movieDB/movies.xml")//movie
          where $a/id = $mid/id
          return $a
        ),
        for $mid in doc("movieDB/scredits.xml")//cast
        where $mid/cast/item/original_name = $s
        return (
        for $a in doc("movieDB/series.xml")//serie
          where $a/id = $mid/id
          return $a
        ),
        for $mid in doc("movieDB/scredits.xml")//cast
        where $mid/crew/item/original_name = $s
        return (
        for $a in doc("movieDB/series.xml")//serie
          where $a/id = $mid/id
          return $a
        )
   }</items>
};

declare function funcs:get-all-series-ordered-genre($g, $i){
  <series>{
  if ($i = 1) then (
  for $a in funcs:get-genre-series($g)//serie
  order by $a/vote_average/text()/xs:double(.) descending
  return $a
  )
  else if ($i = 2) then (
  for $a in funcs:get-genre-series($g)//serie
  order by $a/popularity/text()/xs:double(.) descending
    return $a
  )
  else if ($i =3) then (
  for $a in funcs:get-genre-series($g)//serie
  order by $a/name/text()/xs:string(.)
  return $a
  )
  }</series>
};
declare function funcs:get-all-movies-ordered-genre($g, $i){
  <movies>{
  if ($i = 1) then (
  for $a in funcs:get-genre-movies($g)//movie
  order by $a/vote_average/text()/xs:double(.) descending
  return $a
  )
  else if ($i = 2) then (
  for $a in funcs:get-genre-movies($g)//movie
  order by $a/popularity/text()/xs:double(.) descending
    return $a
  )
  else if ($i = 3) then (
  for $a in funcs:get-genre-movies($g)//movie
  order by $a/original_title/text()/xs:string(.)
  return $a
  )
 }</movies>
};
declare function funcs:get-all-movies-ordered($i){
  <movies>{
  if ($i = 1) then (
  for $a in doc("movieDB/movies.xml")//movie
  order by $a/vote_average/text()/xs:double(.) descending
  return $a
  )
  else if ($i = 2) then (
  for $a in doc("movieDB/movies.xml")//movie
  order by $a/popularity/text()/xs:double(.) descending
    return $a
  )
  else if ($i =3) then (
  for $a in doc("movieDB/movies.xml")//movie
  order by $a/original_title/text()/xs:string(.)
  return $a
  )
  }</movies>
};

declare function funcs:get-all-series-ordered($i){
  <series>{
  if ($i = 1) then (
  for $a in doc("movieDB/series.xml")//serie
  order by $a/vote_average/text()/xs:double(.) descending
  return $a
  )
  else if ($i = 2) then (
  for $a in doc("movieDB/series.xml")//serie
  order by $a/popularity/text()/xs:double(.) descending
    return $a
  )
  else if ($i =3) then (
  for $a in doc("movieDB/series.xml")//serie
  order by $a/name/text()/xs:string(.)
  return $a
  )
  }</series>
};
declare function funcs:get-fullinfo($id) {
    <movie>{
        for $b in doc("movieDB/movies.xml")//movie
        where $b/id = $id
        return (
          $b/id,
          $b/original_title,
          $b/poster_path,
          $b/popularity,
          $b/vote_average,
          $b/vote_count,
          $b/release_date,
          $b/runtime,
          for $c in $b/genres/item/name
          return <genre>{$c/text()}</genre>,
          $b/overview,
          for $c in $b/production_companies/item/name
          return <prod_companie>{$c/text()}</prod_companie>,
          for $a in doc("movieDB/casts.xml")//cast
            where $a/id = $id
            return (
                <credit>{
                $a/id,
                <cast>{
                  for $b in $a/cast/item
                  return (
                    <character>{
                      $b/character,
                      $b/popularity,
                      $b/original_name,
                      $b/profile_path
                    }</character>
                  )
                }</cast>,
                for $c in $a/crew/item
                return(
                  <crew>{
                    $c/original_name,
                    $c/popularity,
                    $c/profile_path,
                    $c/job
                  }</crew>
                )
                }</credit>
              )
         )
    }</movie>
};
declare function funcs:get-fullserieinfo($id) {
  <serie>{
  for $b in doc("movieDB/series.xml")//serie
  where $b/id = $id
  return (
      $b/id,
      $b/original_name,
      $b/overview,
      $b/status,
      $b/poster_path,
      $b/first_air_date,
      $b/vote_average,
      $b/vote_count,
      $b/popularity,
      $b/number_of_episodes,
      $b/number_of_seasons,
      for $g in $b/genres/item/name
      return <genre>{$g}</genre>,
      for $net in $b/networks/item
      return <network>{$net/name/text()}</network>,
      for $com in $b/production_companies/item
      return <companie>{$com/name/text()}</companie>,
      for $a in doc("movieDB/scredits.xml")//cast
      where $a/id = $id
      return (
          <credit>{
          $a/id,
          <cast>{
            for $b in $a/cast/item
            return (
              <charecter>{
                $b/character,
                $b/popularity,
                $b/original_name,
                $b/profile_path
              }</charecter>
            )
          }</cast>,
          for $c in $a/crew/item
          return(
            <crew>{
              $c/original_name, 
              $c/popularity,
              $c/profile_path,
              $c/job
            }</crew>
          )
          }</credit>
        )
  )}</serie>
};

declare function funcs:get-review($id){
  <review>{
  for $a in doc("movieDB/reviews.xml")//review[id=$id]
  return ($a/id, $a/results/item)
  }</review>
};
declare function funcs:get-sreview($id){
  <review>{
  for $a in doc("movieDB/sreviews.xml")//review[id=$id]
  return ($a/id, $a/results/item)
  }</review>
};

declare updating function funcs:insert-review($id, $name, $content) {
  let $nid := doc("movieDB/reviews.xml")//review[id=$id]/results/item[last()]/id+1
  let $a := doc("movieDB/reviews.xml")//review[id=$id]/results 
  return if(exists($nid)) then ( 
    insert node <item><author>{$name}</author><content>{$content}</content><id>{$nid}</id></item> into $a
  )else(
    insert node <item><author>{$name}</author><content>{$content}</content><id>1</id></item> into $a
  )
};

declare updating function funcs:insert-sreview($id, $name, $content) {
  let $nid := doc("movieDB/sreviews.xml")//review[id=$id]/results/item[last()]/id+1
  let $a := doc("movieDB/sreviews.xml")//review[id=$id]/results 
  return if(exists($nid)) then ( 
    insert node <item><author>{$name}</author><content>{$content}</content><id>{$nid}</id></item> into $a
  )else(
    insert node <item><author>{$name}</author><content>{$content}</content><id>1</id></item> into $a
  )
};

declare updating function funcs:update-sreview($id, $rid, $content) {
  for $a in doc("movieDB/sreviews.xml")//review[id=$id]/results/item
  where $a/id = $rid
  return delete node $a
};

declare updating function funcs:update-review($id, $rid, $content) {
  for $a in doc("movieDB/reviews.xml")//review[id=$id]/results/item
  where $a/id = $rid
  return replace node $a/content/text() with $content
};

declare updating function funcs:delete-review($id, $rid) {
  for $a in doc("movieDB/reviews.xml")//review[id=$id]/results/item
  where $a/id = $rid
  return delete node $a
};

declare updating function funcs:delete-sreview($id, $rid) {
  for $a in doc("movieDB/sreviews.xml")//review[id=$id]/results/item
  where $a/id = $rid
  return delete node $a
};

