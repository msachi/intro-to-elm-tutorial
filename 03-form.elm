module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import String exposing (length, any, all, isEmpty)
import Char exposing (isDigit, isLower, isUpper)


main =
    Html.beginnerProgram
        { model = model
        , view = view
        , update = update
        }



-- MODEL


type alias Model =
    { name : String
    , password : String
    , passwordAgain : String
    , age : String
    , alien : Bool
    , validate : Bool
    }


model : Model
model =
    Model "" "" "" "" False False



-- UPDATE


type Msg
    = Name String
    | Password String
    | PasswordAgain String
    | Age String
    | ToggleAlien
    | Validate


update : Msg -> Model -> Model
update msg model =
    case msg of
        Name name ->
            { model | name = name, validate = False }

        Password password ->
            { model | password = password, validate = False }

        PasswordAgain password ->
            { model | passwordAgain = password, validate = False }

        Age age ->
            { model | age = age, validate = False }

        ToggleAlien ->
            { model | alien = not model.alien }

        Validate ->
            { model | validate = True }



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ input [ type_ "text", placeholder "Name", onInput Name ] []
        , input [ type_ "password", placeholder "Password", onInput Password ] []
        , input [ type_ "password", placeholder "Re-enter Password", onInput PasswordAgain ] []
        , input [ type_ "text", placeholder "Age", onInput Age ] []
        , label [ style [ ( "padding", "20px" ) ] ] [ input [ type_ "checkbox", onClick ToggleAlien ] [], text "I am not an alien" ]
        , button [ onClick Validate ] [ text "Submit" ]
        , viewValidation model
        ]


viewValidation : Model -> Html msg
viewValidation model =
    let
        ( color, message ) =
            if model.validate then
                if length model.password < 8 then
                    ( "red", "Password too short!" )
                else if any isUpper model.password == False then
                    ( "red", "Password does not contain an upper case character!" )
                else if any isLower model.password == False then
                    ( "red", "Password does not contain a lower case character!" )
                else if any isDigit model.password == False then
                    ( "red", "Password does not contain a numeric character!" )
                else if model.password /= model.passwordAgain then
                    ( "red", "Passwords do not match!" )
                else if isEmpty model.age || all isDigit model.age == False then
                    ( "red", "Age is not a number!" )
                else if not model.alien then
                    ( "red", "Apologies but our service is currently limited to humans." )
                else
                    ( "green", "OK" )
            else
                ( "black", "waiting..." )
    in
        div [ style [ ( "color", color ) ] ] [ text message ]
