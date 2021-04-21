Plivo Two Factor Auth Example
=======================================

## About

This example shows how [Plivo APIs](http://plivo.com/api) can be used to integrate a two factor authentication system into your own web application. This example is built in Ruby using Sinatra Framework.

In other languages:
<table>
   <tr>
      <td>.Net</td>
      <td><a href="https://github.com/plivo-dev/2FA_Csharp">Done</a></td>
   </tr>
   <tr>
      <td>Python</td>
      <td><a href="https://github.com/plivo-dev/2FA_FlaskApp">Done</a></td>
   </tr>
   <tr>
      <td>NodeJS</td>
      <td><a href="https://github.com/plivo-dev/2FA_ExpressApp">Done</a></td>
   </tr>
   <tr>
      <td>PHP</td>
      <td><a href="https://github.com/plivo-dev/2FA_PHP">Done</a></td>
   </tr>
</table>

## Set up

### Requirements

- Ruby version >= 2.6.x.
- A Plivo account - [sign up](https://console.plivo.com/accounts/register/)

### Local Development

This application verifies your phone number using the two factor authentication system.

1. Clone this repo.
    ```shell
    git clone git@github.com:plivo-dev/2FA_SinatraApp.git    
    ```
2. Change your working directory to 2FA_SinatraApp
    ```shell
    cd 2FA_SinatraApp
    ```
3. Install the dependencies using the `Gemfile`. You can use the below command.
    ```shell
    bundle install
    ```
4. Change the placeholders in the `config.yaml` file. You should replace the PLIVO_AUTH_ID, PLIVO_AUTH_TOKEN, PLIVO_NUMBER & PHLO_ID placeholders.
    **Note:** If you do not want to use PHLO, then set the value to`PHLO_ID = null`

5. You can get your auth_id & auth_token from your [Plivo Console](http://console.plivo.com/). Please [sign up](https://console.plivo.com/accounts/register/) for a Plivo account if you do not have one already. 
    
    **Note:** Enter your phone number in [E.164](http://en.wikipedia.org/wiki/E.164) format. 
6. Use the below command to start the app. 
    ```shell
    ruby app.rb
    ```
### How it works
1. Enter your phone number and click on `Send Verification Code`. 
2. This sends an SMS to that number with a random security code in it. The application now shows a text box to enter this code to verify your mobile number. 
3. Once you get the code in the SMS, enter the code in the text box and click `Verify`. This will tell you whether the code you entered is correct or not. 
4. If you enter the correct code, then the application knows that the phone number belongs to you and thus the number is verified.

Helper libraries for various languages are available on the [Plivo github page](http://github.com/plivo).