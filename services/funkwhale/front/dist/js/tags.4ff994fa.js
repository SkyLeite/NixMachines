(window["webpackJsonp"]=window["webpackJsonp"]||[]).push([["tags"],{"05fe":function(t,e,a){"use strict";var i=function(){var t=this,e=t.$createElement,a=t._self._c||e;return a("div",{staticClass:"wrapper"},[t.header?a("h3",{staticClass:"ui header"},[t._t("title"),a("span",{staticClass:"ui tiny circular label"},[t._v(t._s(t.count))])],2):t._e(),t.search?a("inline-search-bar",{on:{search:function(e){t.objects=[],t.fetchData()}},model:{value:t.query,callback:function(e){t.query=e},expression:"query"}}):t._e(),a("div",{staticClass:"ui hidden divider"}),a("div",{staticClass:"ui five app-cards cards"},[t.isLoading?a("div",{staticClass:"ui inverted active dimmer"},[a("div",{staticClass:"ui loader"})]):t._e(),t._l(t.objects,(function(t){return a("artist-card",{key:t.id,attrs:{artist:t}})}))],2),t.isLoading||0!==t.objects.length?t._e():t._t("empty-state",(function(){return[a("empty-state",{attrs:{refresh:!0},on:{refresh:t.fetchData}})]})),t.nextPage?[a("div",{staticClass:"ui hidden divider"}),t.nextPage?a("button",{class:["ui","basic","button"],on:{click:function(e){return t.fetchData(t.nextPage)}}},[a("translate",{attrs:{"translate-context":"*/*/Button,Label"}},[t._v(" Show more ")])],1):t._e()]:t._e()],2)},s=[],r=a("2909"),n=a("5530"),l=(a("99af"),a("bc3a")),o=a.n(l),c=a("0292"),d={components:{ArtistCard:c["a"]},props:{filters:{type:Object,required:!0},controls:{type:Boolean,default:!0},header:{type:Boolean,default:!0},search:{type:Boolean,default:!1}},data:function(){return{objects:[],limit:12,count:0,isLoading:!1,errors:null,previousPage:null,nextPage:null,query:""}},watch:{offset:function(){this.fetchData()},"$store.state.moderation.lastUpdate":function(){this.fetchData()}},created:function(){this.fetchData()},methods:{fetchData:function(t){t=t||"artists/",this.isLoading=!0;var e=this,a=Object(n["a"])({q:this.query},this.filters);a.page_size=this.limit,a.offset=this.offset,o.a.get(t,{params:a}).then((function(t){e.previousPage=t.data.previous,e.nextPage=t.data.next,e.isLoading=!1,e.objects=[].concat(Object(r["a"])(e.objects),Object(r["a"])(t.data.results)),e.count=t.data.count}),(function(t){e.isLoading=!1,e.errors=t.backendErrors}))},updateOffset:function(t){t?this.offset+=this.limit:this.offset=Math.max(this.offset-this.limit,0)}}},u=d,h=a("2877"),f=Object(h["a"])(u,i,s,!1,null,null,null);e["a"]=f.exports},"0b21":function(t,e,a){"use strict";a.r(e);var i=function(){var t=this,e=t.$createElement,a=t._self._c||e;return a("main",{directives:[{name:"title",rawName:"v-title",value:t.labels.title,expression:"labels.title"}]},[a("section",{staticClass:"ui vertical stripe segment"},[a("h2",{staticClass:"ui header"},[a("span",{staticClass:"ui circular huge hashtag label component-label"},[t._v(" "+t._s(t.labels.title)+" ")])]),a("radio-button",{attrs:{type:"tag","object-id":t.id}}),t.$store.state.auth.availablePermissions["library"]?a("router-link",{staticClass:"ui right floated button",attrs:{to:{name:"manage.library.tags.detail",params:{id:t.id}}}},[a("i",{staticClass:"wrench icon"}),a("translate",{attrs:{"translate-context":"Content/Moderation/Link"}},[t._v(" Open in moderation interface ")])],1):t._e(),a("div",{staticClass:"ui hidden divider"}),a("div",{staticClass:"ui row"},[a("artist-widget",{key:"artist"+t.id,attrs:{controls:!1,filters:{playable:!0,ordering:"-creation_date",tag:t.id,include_channels:"false"}}},[a("template",{slot:"title"},[a("router-link",{attrs:{to:{name:"library.artists.browse",query:{tag:t.id}}}},[a("translate",{attrs:{"translate-context":"*/*/*/Noun"}},[t._v(" Artists ")])],1)],1)],2),a("div",{staticClass:"ui hidden divider"}),a("div",{staticClass:"ui hidden divider"}),a("h3",{staticClass:"ui header"},[a("translate",{attrs:{"translate-context":"*/*/*"}},[t._v(" Channels ")])],1),a("channels-widget",{key:"channels"+t.id,attrs:{"show-modification-date":!0,limit:12,filters:{tag:t.id,ordering:"-creation_date"}}}),a("div",{staticClass:"ui hidden divider"}),a("div",{staticClass:"ui hidden divider"}),a("album-widget",{key:"album"+t.id,attrs:{"show-count":!0,controls:!1,filters:{playable:!0,ordering:"-creation_date",tag:t.id}}},[a("template",{slot:"title"},[a("router-link",{attrs:{to:{name:"library.albums.browse",query:{tag:t.id}}}},[a("translate",{attrs:{"translate-context":"*/*/*"}},[t._v(" Albums ")])],1)],1)],2),a("div",{staticClass:"ui hidden divider"}),a("div",{staticClass:"ui hidden divider"}),a("track-widget",{key:"track"+t.id,attrs:{"show-count":!0,limit:12,"item-classes":"track-item inline",url:"/tracks/","is-activity":!1,filters:{playable:!0,ordering:"-creation_date",tag:t.id}}},[a("template",{slot:"title"},[a("translate",{attrs:{"translate-context":"*/*/*"}},[t._v(" Tracks ")])],1)],2),a("div",{staticClass:"ui clearing hidden divider"})],1)],1)])},s=[],r=a("a5fd"),n=a("359d"),l=a("8356"),o=a("05fe"),c=a("d4fd"),d={components:{ArtistWidget:o["a"],AlbumWidget:l["a"],TrackWidget:n["a"],RadioButton:c["a"],ChannelsWidget:r["a"]},props:{id:{type:String,required:!0}},computed:{labels:function(){var t="#".concat(this.id);return{title:t}},isAuthenticated:function(){return this.$store.state.auth.authenticated},hasFavorites:function(){return this.$store.state.favorites.count>0}}},u=d,h=a("2877"),f=Object(h["a"])(u,i,s,!1,null,null,null);e["default"]=f.exports},"271e":function(t,e,a){t.exports=a.p+"img/default-cover.89d13c2f.png"}}]);