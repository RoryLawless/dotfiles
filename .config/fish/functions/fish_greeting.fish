function fish_greeting

    set GREETING \
    "Hello!" \
    "Hi!" \
    "Hey!" \
    "Howdy!" \
    "Greetings!" \
    "Good day!" \
    "What's up?" \
    "How's it going?" \
    "Yo!" \
    "Hiya!" \
    "Salutations!" \
    "How do you do?" \
    "Bonjour!" \
    "Hola!" \
    "Guten Tag!" \
    "Ciao!" \
    "Namaste!" \
    "Salaam!" \
    "Konnichiwa!" \
    "Shalom!"

    set TIME (date '+%H:%M %Z')
    set DATE (date '+%A, %d %B %Y')

    set RANDOM_GREETING (random)"%"(count $GREETING)
	set RANDOM_GREETING $GREETING[(math $RANDOM_GREETING"+1")]


    printf (set_color purple;)"$RANDOM_GREETING It is $TIME on $DATE.\n"
    fortune -s | cowsay | lolcat
end