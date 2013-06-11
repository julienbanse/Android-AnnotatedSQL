Android-AnnotatedSQL
====================

Android library for auto generating SQL schema and Content Provider by annotations. You will get a full-featured content provider in 5 minutes :)


This project is an eclipse plugin to generate SQL schema and Content provider by annotations for Android project. It's annotation processor so it will not add some code to your final apk.
It will work during compile process

[eclipse update site][1]

[github][2]

To use this library in project you should install plugin to eclipse and add Annotation Library to build path(Project properties->Java Build Path->Libraries->Add Library).

After that you should turn on annotation preprocessing for your project on the project properties screen and select plugin in factory path section.

To use with ant you should add plugin to classpath only:

`ant clean release -cp ../AnnotatedSQLProcessor.jar`

The lib suppport common annotations to build tables, viewes, indexes, provider and provider query 

Also plugin provides templates to create these structures.  

Define scheme and provider
--------
----------
*Root interface*
--------
Define all tables in the root interface. 

    @Schema(className="FSchema", dbName="football.db", dbVersion=1)
    @Provider(authority="com.gdubina.football.providers.rss", schemaClass="FSchema", name="FProvider", openHelperClass="CustomOpenHelper")
    public interface FStore {

**Shema** - define schema class name, db file name and version. *FSchema.java* will contain all necessary sql code. *FSchema2.java* will be generated too. It will contains constants to access view/query's columns. 

**Provider** - can use autogenerated open helper class or your own.
Auto generated class doesn't have ability to upgrate db. It will drop old db an create new. So openHelperClass attribute is optional.

*Define table*
----------------
Use tipical annotations to define table.
You can use **@PrimaryKey, @Autoincrement, @NotNull, @Unique** annotation to define column. Also you can add **@Index** or **@PrimaryKey** by few columns for table.

To allow access to the table over content provider use **@URI** to mark content path 

    @Table(TeamTable.TABLE_NAME)
    public static interface TeamTable{
		
        String TABLE_NAME = "team_table";
		
		@URI
		String CONTENT_URI = "team_table";

		@PrimaryKey
		@Column(type = Type.INTEGER)
		String ID = "_id";
		
		@Column(type = Type.TEXT)
		String TITLE = "title";
		
		@Column(type = Type.INTEGER)
		String CHEMP_ID = "chemp_id";
	}
*Define view*
----------------
View is useful mechanism to aggregate data. You can use **@Join**, **@RawJoin** to join tables. The library support all join types: INNER, LEFT, RIGHT, CROSS

You can define selected columns from each tables if you want. Use **@Columns** or **@IgnoreColumns** to limit selected columns. 
 

	@SimpleView(ResultView.VIEW_NAME)
	public static interface ResultView {

		@URI(type = URI.Type.DIR, onlyQuery = true)
		String URI_CONTENT = "result_view";

		String VIEW_NAME = "result_view";

		@From(ResultsTable.TABLE_NAME)
		String TABLE_RESULT = "result_t";

		@Join(joinTable = TeamTable.TABLE_NAME, joinColumn = TeamTable.ID, onTableAlias = TABLE_RESULT, onColumn = ResultsTable.TEAM_ID)
		String TABLE_TEAM = "team_t";
		
	}

*Define raw query*
----------------
Query definition is similar to view. In the query you can use **@SqlQuery** annotation to write raw sql.

Query will be called in content provider and you can use parameters in the body. to define parameters use **'?'** symbol and provide arguments in query request

	@RawQuery(LastScoreQuery.QUERY_NAME)
	public static interface LastScoreQuery{
		
		String QUERY_NAME = "last_score_query";
		
		@URI
		String CONTENT_PATH = "last_score_query";
		
		@SqlQuery
		String QUERY = "select * from " + ScoreView.VIEW_NAME + " where " + ScoreView.TABLE_SCORE + "_" + ScoreTable.IS_LAST_TOUR + " = 1";
	}

*URI*
----------------
Use **@URI** annotation to mark content path of entites, viewes or queries. Provider class will have a few methods to create content uri. 

Important feature of the **@URI** - alternative notify uris. It's the list of uris which will be notified with content uri. 
So if we insert data to the *Team* table provider will notify *ScoreView* and *ResultView* uris too and UI refresh data.


	@Table(TeamTable.TABLE_NAME)
	public static interface TeamTable{
		
		String TABLE_NAME = "team_table";
		
		@URI(altNotify={ScoreView.CONTENT_PATH, ResultView.URI_CONTENT})
		String CONTENT_URI = "team_table";


*no-notify feature*
----------------
If you insert a lot data you should prevent UI update after each insert and make notify when all data is stored.

So use **Provider.getNoNotifyContentUri** for insert operation 
and **Provider.notifyUri** to notify UI about changes.

	private static final Uri URI_TEAM_TABLE = FProvider.getNoNotifyContentUri(TeamTable.CONTENT_URI);
    	.....
    cr.bulkInsert(URI_TEAM_TABLE, teams.toArray(new ContentValues[teams.size()]));
    	.....
    FProvider.notifyUri(cr, FProvider.getContentUri(TeamTable.CONTENT_URI));

*Trigger feature*
----------------
if you want to call some code before or after some actions in content provider use **@Trigger** annotation for **@URI** field.

My trigger is similar to sql trigger :) Plugin will generate specific methods in provider. You should inherit autogenerated provider and override methods. 

Define trigger:

	@Table(User.TABLE_NAME)
	public static interface User{

		@Trigger(type=Trigger.Type.INSERT, name="user", when=When.BEFORE)
		@URI(altNotify={SuggestionView.URI_CONTENT, MessageChatView.URI_CONTENT, ChatListQuery.URI_CONTENT})
		String URI_CONTENT = "user";

Inherid provider:

    public class AppProvider extends AppAutoProvider {
        @Override
    	protected void onUserBeforeInserted(ContentValues values) {
            .....
        }
    


  [1]: http://dl.dropbox.com/u/8604560/plugins/annotatedsql
  [2]: https://github.com/hamsterksu/Android-AnnotatedSQL