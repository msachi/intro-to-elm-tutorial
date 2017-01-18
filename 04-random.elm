module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Random
import String exposing (..)


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { dieFaceA : Int
    , dieFaceB : Int
    }


init : ( Model, Cmd Msg )
init =
    ( Model 0 0, Cmd.none )



-- UPDATE


type Msg
    = Roll
    | NewFaceA Int
    | NewFaceB Int


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Roll ->
            ( model, Random.generate NewFaceA (Random.int 1 6) )

        NewFaceA newFace ->
            ( { model | dieFaceA = newFace }, Random.generate NewFaceB (Random.int 1 6) )

        NewFaceB newFace ->
            ( { model | dieFaceB = newFace }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- UTILITIES


createImage : Int -> String
createImage dieFace =
    concat [ "./4-random/", (toString dieFace), ".png" ]



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ img [ style [ ( "width", "10%" ) ], src (createImage model.dieFaceA) ] []
          --, h1 [] [ text (toString model.dieFaceA) ]
        , img [ style [ ( "width", "10%" ) ], src (createImage model.dieFaceB) ] []
          --, h1 [] [ text (toString model.dieFaceB) ]
        , button [ onClick Roll ] [ text "Roll" ]
        , viewValidation model
        ]


viewValidation : Model -> Html msg
viewValidation model =
    let
        ( color, message ) =
            if (model.dieFaceA == model.dieFaceB) then
                ( "green", "JACKPOT" )
            else
                ( "red", "They're different - try again" )
    in
        h1 [ style [ ( "color", color ) ] ] [ text message ]
