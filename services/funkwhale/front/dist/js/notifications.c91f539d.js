(window["webpackJsonp"]=window["webpackJsonp"]||[]).push([["notifications"],{fda7:function(t,e,a){"use strict";a.r(e);var i=function(){var t=this,e=t.$createElement,a=t._self._c||e;return a("main",{directives:[{name:"title",rawName:"v-title",value:t.labels.title,expression:"labels.title"}],staticClass:"main pusher page-notifications"},[a("section",{staticClass:"ui vertical aligned stripe segment"},[a("div",{staticClass:"ui container"},[t.additionalNotifications?a("div",{staticClass:"ui container"},[a("h1",{staticClass:"ui header"},[a("translate",{attrs:{"translate-context":"Content/Notifications/Title"}},[t._v(" Your messages ")])],1),a("div",{staticClass:"ui two column stackable grid"},[t.showInstanceSupportMessage?a("div",{staticClass:"column"},[a("div",{staticClass:"ui attached info message"},[a("h4",{staticClass:"header"},[a("translate",{attrs:{"translate-context":"Content/Notifications/Header"}},[t._v(" Support this Funkwhale pod ")])],1),a("div",{domProps:{innerHTML:t._s(t.markdown.makeHtml(t.$store.state.instance.settings.instance.support_message.value))}})]),a("div",{staticClass:"ui bottom attached segment"},[a("form",{staticClass:"ui inline form",on:{submit:function(e){return e.preventDefault(),t.setDisplayDate("instance_support_message_display_date",t.instanceSupportMessageDelay)}}},[a("div",{staticClass:"inline field"},[a("label",{attrs:{for:"instance-reminder-delay"}},[a("translate",{attrs:{"translate-context":"Content/Notifications/Label"}},[t._v("Remind me in:")])],1),a("select",{directives:[{name:"model",rawName:"v-model",value:t.instanceSupportMessageDelay,expression:"instanceSupportMessageDelay"}],attrs:{id:"instance-reminder-delay"},on:{change:function(e){var a=Array.prototype.filter.call(e.target.options,(function(t){return t.selected})).map((function(t){var e="_value"in t?t._value:t.value;return e}));t.instanceSupportMessageDelay=e.target.multiple?a:a[0]}}},[a("option",{domProps:{value:30}},[a("translate",{attrs:{"translate-context":"*/*/*"}},[t._v(" 30 days ")])],1),a("option",{domProps:{value:60}},[a("translate",{attrs:{"translate-context":"*/*/*"}},[t._v(" 60 days ")])],1),a("option",{domProps:{value:90}},[a("translate",{attrs:{"translate-context":"*/*/*"}},[t._v(" 90 days ")])],1),a("option",{domProps:{value:null}},[a("translate",{attrs:{"translate-context":"*/*/*"}},[t._v(" Never ")])],1)]),a("button",{staticClass:"ui right floated basic button",attrs:{type:"submit"}},[a("translate",{attrs:{"translate-context":"Content/Notifications/Button.Label"}},[t._v(" Got it! ")])],1)])])])]):t._e(),t.showFunkwhaleSupportMessage?a("div",{staticClass:"column"},[a("div",{staticClass:"ui info attached message"},[a("h4",{staticClass:"header"},[a("translate",{attrs:{"translate-context":"Content/Notifications/Header"}},[t._v(" Do you like Funkwhale? ")])],1),a("p",[a("translate",{attrs:{"translate-context":"Content/Notifications/Paragraph"}},[t._v(" We noticed you've been here for a while. If Funkwhale is useful to you, we could use your help to make it even better! ")])],1),a("a",{staticClass:"ui primary inverted button",attrs:{href:"https://funkwhale.audio/support-us",target:"_blank",rel:"noopener"}},[a("translate",{attrs:{"translate-context":"Content/Notifications/Button.Label/Verb"}},[t._v("Donate")])],1),a("a",{staticClass:"ui secondary inverted button",attrs:{href:"https://contribute.funkwhale.audio",target:"_blank",rel:"noopener"}},[a("translate",{attrs:{"translate-context":"Content/Notifications/Button.Label/Verb"}},[t._v("Discover other ways to help")])],1)]),a("div",{staticClass:"ui bottom attached segment"},[a("form",{staticClass:"ui inline form",on:{submit:function(e){return e.preventDefault(),t.setDisplayDate("funkwhale_support_message_display_date",t.funkwhaleSupportMessageDelay)}}},[a("div",{staticClass:"inline field"},[a("label",{attrs:{for:"funkwhale-reminder-delay"}},[a("translate",{attrs:{"translate-context":"Content/Notifications/Label"}},[t._v("Remind me in:")])],1),a("select",{directives:[{name:"model",rawName:"v-model",value:t.funkwhaleSupportMessageDelay,expression:"funkwhaleSupportMessageDelay"}],attrs:{id:"funkwhale-reminder-delay"},on:{change:function(e){var a=Array.prototype.filter.call(e.target.options,(function(t){return t.selected})).map((function(t){var e="_value"in t?t._value:t.value;return e}));t.funkwhaleSupportMessageDelay=e.target.multiple?a:a[0]}}},[a("option",{domProps:{value:30}},[a("translate",{attrs:{"translate-context":"*/*/*"}},[t._v(" 30 days ")])],1),a("option",{domProps:{value:60}},[a("translate",{attrs:{"translate-context":"*/*/*"}},[t._v(" 60 days ")])],1),a("option",{domProps:{value:90}},[a("translate",{attrs:{"translate-context":"*/*/*"}},[t._v(" 90 days ")])],1),a("option",{domProps:{value:null}},[a("translate",{attrs:{"translate-context":"*/*/*"}},[t._v(" Never ")])],1)]),a("button",{staticClass:"ui right floated basic button",attrs:{type:"submit"}},[a("translate",{attrs:{"translate-context":"Content/Notifications/Button.Label"}},[t._v(" Got it! ")])],1)])])])]):t._e()])]):t._e(),a("h1",{staticClass:"ui header"},[a("translate",{attrs:{"translate-context":"Content/Notifications/Title"}},[t._v(" Your notifications ")])],1),a("div",{staticClass:"ui toggle checkbox"},[a("input",{directives:[{name:"model",rawName:"v-model",value:t.filters.is_read,expression:"filters.is_read"}],attrs:{id:"show-read-notifications",type:"checkbox"},domProps:{checked:Array.isArray(t.filters.is_read)?t._i(t.filters.is_read,null)>-1:t.filters.is_read},on:{change:function(e){var a=t.filters.is_read,i=e.target,n=!!i.checked;if(Array.isArray(a)){var o=null,s=t._i(a,o);i.checked?s<0&&t.$set(t.filters,"is_read",a.concat([o])):s>-1&&t.$set(t.filters,"is_read",a.slice(0,s).concat(a.slice(s+1)))}else t.$set(t.filters,"is_read",n)}}}),a("label",{attrs:{for:"show-read-notifications"}},[a("translate",{attrs:{"translate-context":"Content/Notifications/Form.Label/Verb"}},[t._v("Show read notifications")])],1)]),!1===t.filters.is_read&&t.notifications.count>0?a("button",{staticClass:"ui basic labeled icon right floated button",on:{click:function(e){return e.preventDefault(),t.markAllAsRead.apply(null,arguments)}}},[a("i",{staticClass:"ui check icon"}),a("translate",{attrs:{"translate-context":"Content/Notifications/Button.Label/Verb"}},[t._v(" Mark all as read ")])],1):t._e(),a("div",{staticClass:"ui hidden divider"}),t.isLoading?a("div",{class:["ui",{active:t.isLoading},"inverted","dimmer"]},[a("div",{staticClass:"ui text loader"},[a("translate",{attrs:{"translate-context":"Content/Notifications/Paragraph"}},[t._v(" Loading notifications… ")])],1)]):t.notifications.count>0?a("table",{staticClass:"ui table"},[a("tbody",t._l(t.notifications.results,(function(t){return a("notification-row",{key:t.id,attrs:{"initial-item":t}})})),1)]):0===t.additionalNotifications?a("p",[a("translate",{attrs:{"translate-context":"Content/Notifications/Paragraph"}},[t._v(" No notification to show. ")])],1):t._e()])])])},n=[],o=a("5530"),s=(a("4160"),a("d3b7"),a("159b"),a("2f62")),r=a("bc3a"),l=a.n(r),c=a("339e"),u=a.n(c),d=a("c1df"),f=a.n(d),p=function(){var t=this,e=t.$createElement,a=t._self._c||e;return a("tr",{class:[{"disabled-row":t.item.is_read}]},[a("td",[a("actor-link",{staticClass:"user",attrs:{actor:t.item.activity.actor}})],1),a("td",[t.notificationData.detailUrl?a("router-link",{staticClass:"link",attrs:{tag:"span",to:t.notificationData.detailUrl},domProps:{innerHTML:t._s(t.notificationData.message)}}):void 0,t.notificationData.acceptFollow?[t._v("   "),a("button",{class:["ui","basic","tiny",t.notificationData.acceptFollow.buttonClass||"","button"],on:{click:function(e){return t.handleAction(t.notificationData.acceptFollow.handler)}}},[t.notificationData.acceptFollow.icon?a("i",{class:[t.notificationData.acceptFollow.icon,"icon"]}):t._e(),t._v(" "+t._s(t.notificationData.acceptFollow.label)+" ")]),a("button",{class:["ui","basic","tiny",t.notificationData.rejectFollow.buttonClass||"","button"],on:{click:function(e){return t.handleAction(t.notificationData.rejectFollow.handler)}}},[t.notificationData.rejectFollow.icon?a("i",{class:[t.notificationData.rejectFollow.icon,"icon"]}):t._e(),t._v(" "+t._s(t.notificationData.rejectFollow.label)+" ")])]:t._e()],2),a("td",[a("human-date",{attrs:{date:t.item.activity.creation_date}})],1),a("td",{staticClass:"read collapsing"},[t.item.is_read?a("a",{staticClass:"discrete link",attrs:{href:"","aria-label":t.labels.markUnread,title:t.labels.markUnread},on:{click:function(e){return e.preventDefault(),t.markRead(!1)}}},[a("i",{staticClass:"redo icon"})]):a("a",{staticClass:"discrete link",attrs:{href:"","aria-label":t.labels.markRead,title:t.labels.markRead},on:{click:function(e){return e.preventDefault(),t.markRead(!0)}}},[a("i",{staticClass:"check icon"})])])])},m=[],h=(a("99af"),{props:{initialItem:{type:Object,required:!0}},data:function(){return{item:this.initialItem}},computed:{message:function(){return"plop"},labels:function(){var t=this.$pgettext("Content/Notifications/Paragraph",'%{ username } followed your library "%{ library }"'),e=this.$pgettext("Content/Notifications/Paragraph",'%{ username } accepted your follow on library "%{ library }"'),a=this.$pgettext("Content/Notifications/Paragraph",'You rejected %{ username }&#39;s request to follow "%{ library }"'),i=this.$pgettext("Content/Notifications/Paragraph",'%{ username } wants to follow your library "%{ library }"');return{libraryFollowMessage:t,libraryAcceptFollowMessage:e,libraryRejectMessage:a,libraryPendingFollowMessage:i,markRead:this.$pgettext("Content/Notifications/Button.Tooltip/Verb","Mark as read"),markUnread:this.$pgettext("Content/Notifications/Button.Tooltip/Verb","Mark as unread")}},username:function(){return this.item.activity.actor.preferred_username},notificationData:function(){var t=this,e=this.item.activity;if("Follow"===e.type&&e.object&&"music.Library"===e.object.type){var a=null,i=null,n=null;return e.related_object&&null===e.related_object.approved?(n=this.labels.libraryPendingFollowMessage,a={buttonClass:"success",icon:"check",label:this.$pgettext("Content/*/Button.Label/Verb","Approve"),handler:function(){t.approveLibraryFollow(e.related_object)}},i={buttonClass:"danger",icon:"x",label:this.$pgettext("Content/*/Button.Label/Verb","Reject"),handler:function(){t.rejectLibraryFollow(e.related_object)}}):n=e.related_object&&e.related_object.approved?this.labels.libraryFollowMessage:this.labels.libraryRejectMessage,{acceptFollow:a,rejectFollow:i,detailUrl:{name:"content.libraries.detail",params:{id:e.object.uuid}},message:this.$gettextInterpolate(n,{username:this.username,library:e.object.name})}}return"Accept"===e.type&&e.object&&"federation.LibraryFollow"===e.object.type?{detailUrl:{name:"content.remote.index"},message:this.$gettextInterpolate(this.labels.libraryAcceptFollowMessage,{username:this.username,library:e.related_object.name})}:{}}},methods:{handleAction:function(t){t(),this.markRead(!0)},approveLibraryFollow:function(t){var e="accept";l.a.post("federation/follows/library/".concat(t.uuid,"/").concat(e,"/")).then((function(e){t.isLoading=!1,t.approved=!0}))},rejectLibraryFollow:function(t){var e="reject";l.a.post("federation/follows/library/".concat(t.uuid,"/").concat(e,"/")).then((function(e){t.isLoading=!1,t.approved=!1}))},markRead:function(t){var e=this;l.a.patch("federation/inbox/".concat(this.item.id,"/"),{is_read:t}).then((function(a){e.item.is_read=t,t?e.$store.commit("ui/incrementNotifications",{type:"inbox",count:-1}):e.$store.commit("ui/incrementNotifications",{type:"inbox",count:1})}))}}}),b=h,v=a("2877"),g=Object(v["a"])(b,p,m,!1,null,null,null),y=g.exports,_={components:{NotificationRow:y},data:function(){return{isLoading:!1,markdown:new u.a.Converter,notifications:{count:0,results:[]},instanceSupportMessageDelay:60,funkwhaleSupportMessageDelay:60,filters:{is_read:!1}}},computed:Object(o["a"])(Object(o["a"])(Object(o["a"])({},Object(s["d"])({events:function(t){return t.instance.events}})),Object(s["c"])({additionalNotifications:"ui/additionalNotifications",showInstanceSupportMessage:"ui/showInstanceSupportMessage",showFunkwhaleSupportMessage:"ui/showFunkwhaleSupportMessage"})),{},{labels:function(){return{title:this.$pgettext("*/Notifications/*","Notifications")}}}),watch:{"filters.is_read":function(){this.fetch(this.filters)}},created:function(){this.fetch(this.filters),this.$store.commit("ui/addWebsocketEventHandler",{eventName:"inbox.item_added",id:"notificationPage",handler:this.handleNewNotification})},destroyed:function(){this.$store.commit("ui/removeWebsocketEventHandler",{eventName:"inbox.item_added",id:"notificationPage"})},methods:{handleNewNotification:function(t){this.notifications.count+=1,this.notifications.results.unshift(t.item)},setDisplayDate:function(t,e){var a,i={};a=e?f()().add({days:e}):null,i[t]=a;var n=this;l.a.patch("users/".concat(this.$store.state.auth.username,"/"),i).then((function(t){n.$store.commit("auth/profilePartialUpdate",t.data)}))},fetch:function(t){this.isLoading=!0;var e=this;l.a.get("federation/inbox/",{params:t}).then((function(t){e.isLoading=!1,e.notifications=t.data}))},markAllAsRead:function(){var t=this,e=this.notifications.results[0].id,a={action:"read",objects:"all",filters:{is_read:!1,before:e}};l.a.post("federation/inbox/action/",a).then((function(e){t.$store.commit("ui/notifications",{type:"inbox",count:0}),t.notifications.results.forEach((function(t){t.is_read=!0}))}))}}},w=_,C=Object(v["a"])(w,i,n,!1,null,null,null);e["default"]=C.exports}}]);