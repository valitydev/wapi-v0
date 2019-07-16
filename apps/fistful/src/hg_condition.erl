-module(hg_condition).
-include_lib("dmsl/include/dmsl_domain_thrift.hrl").

%%

-export([test/2]).

%%

-type condition() :: dmsl_domain_thrift:'Condition'().
-type varset()    :: hg_selector:varset().

-spec test(condition(), varset()) ->
    true | false | undefined.

test({category_is, V1}, #{category := V2}) ->
    V1 =:= V2;
test({currency_is, V1}, #{currency := V2}) ->
    V1 =:= V2;
test({cost_in, V}, #{cost := C}) ->
    hg_cash_range:is_inside(C, V) =:= within;
test({payment_tool, C}, #{payment_tool := V}) ->
    hg_payment_tool:test_condition(C, V);
test({shop_location_is, V}, #{shop := S}) ->
    V =:= S#domain_Shop.location;
test({party, V}, #{party_id := PartyID} = VS) ->
    test_party(V, PartyID, VS);
test({payout_method_is, V1}, #{payout_method := V2}) ->
    V1 =:= V2;
test({identification_level_is, V1}, #{identification_level := V2}) ->
    V1 =:= V2;
test(_, #{}) ->
    undefined.

test_party(#domain_PartyCondition{id = PartyID, definition = Def}, PartyID, VS) ->
    test_party_definition(Def, VS);
test_party(_, _, _) ->
    false.

test_party_definition(undefined, _) ->
    true;
test_party_definition({shop_is, ID1}, #{shop_id := ID2}) ->
    ID1 =:= ID2;
test_party_definition({wallet_is, ID1}, #{wallet_id := ID2}) ->
    ID1 =:= ID2;
test_party_definition(_, _) ->
    undefined.