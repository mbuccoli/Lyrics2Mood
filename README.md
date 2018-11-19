# Lyrics2Mood
Hack during the Abbey Road hackathon

#Inspiration
What if a singer could inspire and lead the performance with his/her words and the sentiment behind it? 

#What it does
Our demo takes as input the voice of a singer, it extracts the lyrics using a Speech to Text algorithm, and then it performs Sentiment Analysis to understand what's the value of valence, i.e., positivity or negativity, expressed by the lyrics. From here, the applications are endless, from getting the music background follow your emotional lead, to change a guitarist effects with the sentiment you convey, up to record short demos of your music ideas, that the system will integrate with a proper musical arrangement.

#How it's done
We used Processing to have real time recording, processing and contacting the Microsoft Cognitive Services for Speech To Text and Sentiment Analysis. Processing was also useful for interacting with an Eventide H9 pedal effect and tell it to switch among presets and values of parameters. Lastly, we used Python to develop a web-based APIs that receives a solo singing track in input and returns a properly arranged audio track (with singing, of course).

#What's next for Lyrics2Mood
The musical model is not complex as we would have liked to. We would like to extend it with algorithmic composition and music generation with neural networks. Also, we intend to further explore the application scenarios, like automatic composition of soundtracks for audio books dependent on the sentiment expressed by the story.

#How to use it
Our Processing sketch is contained in folder AbbeyBlues and allow to run the application in real-time. 
As input for the tool you can use both an external or the builtin microphone. About guitar effects control, our application is tailored on an Eventide H9 pedal.
The offline version of the application can be found in the folder OfflineBlues/WebService and it can be executed by using this command:
	python abbeyblues.py input_filename output_filename.py
