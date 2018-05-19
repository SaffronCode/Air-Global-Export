# Air-Global-Export
This is a package of command saved on a bat file to help you export your swf project and its dependency without need to open your IDE
<p dir="rtl">به کمک فایل ExporterGenerator.bat می توانید فایل swf را به همراه فایل های مورد نیاز و فایل های ane با چند دستور ساده و بدون نیاز به باز کردن محیط برنامه نویسیتان به فرمت های apk و ipa به صورت همزمان تبدیل کنید.</p>
<br>

# <p dir="rtl">نحوه استفاده</p>

<p dir="rtl">
• فایل bat را کنار فایل swf پروژه خود کپی کنید. فولدر آیکون ها و فایل های -app.xml باید در همان فولدر باشند.<br>
• در اولین اجرا فایل تمام تنظیمات مورد نیاز برای خروجی را از شما دریافت می کند. فایل را اجرا کرده و طبق توضیحات پیش روی<br>
  <p align="center">
    <img src="https://github.com/SaffronCode/Air-Global-Export/blob/Documentation/Doc/WhereToSet.JPG?raw=true" dir="center" alt="نحوه ی قرار گیری فایل ExporterGenerator.bat در کنار فایل های دیگر پروژه"/><br><p align="center" dir="rtl">نحوه قرار گیری فایل ExporterGenerator.bat در کنار فایل های دیگر پروژه
</p></p><br><br>

## <p dir="rtl">تنظیمات عمومی-یک بار برای تمام پروژه ها</p>

<p dir="ltr">1- aircompiler:<br></p><p dir="rtl">
برای برنامه نویسانی که با بیش از یک پروژه سرو کار دارند گزینه ی خوبی است که آدرس کامپایلر ادوب ایر خود را یک بار ثبت کنند تا در صورت بروز رسانی کامپایلر، تمام خروجی ها به کمک نسخه ی جدید ایر ایجاد شود. این متغیر از شما آدرس کامپایلر ادوب ایر ذخیره شده روی سیستم عامل شما را درخواست می کند. آدرس فولدر اصلی را وارد کرده و Enter را فشار دهید.<br>
مثال: D:\air\AIRSDK_26<br><br>
• تا زمانی که کامپایلر خود را تغییر نداده اید برای دفعات بعد و یا نرم افزار های بعد می توانید این گزینه را خالی بگذارید تا از آدرس قبلی استفاده شود.<br><br>

</p><p dir="ltr">2-My global natives folder: <br></p><p dir="rtl">
ممکن است از تعداد زیادی فایل ane استفاده کرده باشید. برای اینکه بعد ها در بروز رسانی این کتابخانه ها در نرم افزار های مختلفتان به مشکل نخورید می توانید مانند کامپایلر یه فولدر را به آن اختصاص داده و از دفعات بعدی مقداری برای آن وارد نکنید تا از فولدر اصلی فایل های native ثبت شده استفاده شود.<br>
<br>
  
## <p dir="rtl">تنظیمات اختصاصی-مختص پروژه جاری</p>

</p><p dir="ltr">3-Enter the SWF file name without extenstion:</p><p dir="rtl">وارد کردن نام فایل swf بدون وارد کردن پسوند فایل<br>
مثال:myProject<br><br>

</p><p dir="ltr">4-Enter export file name:</p><p dir="rtl">
<br>نامی که می خواهید فایل های خروجی با آن نام ذخیره شوند. اگر فیلد خالی بماند از نام پروژه استفاده می شود.<br><br>
</p><p dir="ltr">5-Enter the apple development mobileprovision file name without extensnion:<br></p><p dir="rtl">
</p><p dir="ltr">6-Enter the apple production mobileprovision file name without extensnion:<br></p><p dir="rtl">
</p><p dir="ltr">7-Enter the apple adhoc mobileprovision file name without extensnion:<br></p><p dir="rtl">
فایل های mobileprovision برای خروجی های iOS. تمام این فایل ها باید در کنار فایل swf اصلی قرار داده شده باشند و نام آنها بدون پسوند وارد شود. (اگر خروجی iOS ندارید، آنها را خالی رها کنید)<br><br>

</p><p dir="ltr">8-Do you have local native folder? enter its name or pass this questin blank:<br></p><p dir="rtl">
در صورتی که پروژه شما فایل های native مخصوص خودش را دارد، فولدر فایل های native را در کنار پروژه ذخیره کرده و نام آن را وارد کنید.<br><br>

</p><p dir="ltr">9-Enter the name of the apple distribution manifest file:<br>
10-Enter the name of the apple development manifest file:<br>
11-Enter the name of the android development manifest file:<br></p><p dir="rtl">
نام فایل های -app.xml یا manifest پروژه که باید برای نسخه های آندروید، iOS مخصوص پابلیش اپل استور و iOS مخصوص دیباگ و ادهاک نام آنها را به صورت جداگانه وارد کنید. یه نام پیشفرض به شما پیشنهاد می شود که در صورتی که صحیح است فیلد را خالی رها کنید.<br><br>

</p><p dir="ltr">11-If you need to change iOS and Android icons, add "AppIconsForPublish-and" for android icons and "AppIconsForPublish-and" for iOS icons.
These directories should embed with your application: "Data AppIconsForPublish". Enter your own directory if you need to change them:<br></p><p dir="rtl">
فایل های پیشفرض که معمولا با پروژه هایی که از SaffronCode استفاده کرده اند در اینجا به صورت پیشفرض در کنار نرم افزار قرار داده خواهد شد. در صورتی که فایل های دیگری می خواهید در کنار نرم افزار embed شوند و این مقادیر حذف شوند نام فایل ها و فولدر های خود را با یک space ثبت کنید.<br>
مثال:myDataDirecory myImage.jpg otherImage.jpg<br><br>

</p><p dir="ltr">12--D:\Sepehr\MTeam Certifications\MTeam IOS Certificate_dev.p12<br>
Do you need to change your iOS development certificate file? enter the new target or pass this question blank<br>
13--D:\Sepehr\MTeam Certifications\MTeam IOS Certificate.p12<br>
Do you need to change your iOS distribution certificate file? enter the new target or pass this question blank<br>
14--D:\Sepehr\MTeam Certifications\MTeam Certification File.p12<br>
Do you need to change your Android certificate file? enter the new target or pass this question blank<br></p><p dir="rtl">
از شما فایلهای p12 مخصوص خروجی های آندروید، iOS به ترتیب درخواست می شود. می توانید آنها را به صورت آدرس کامل و یا در صورتی که کنار نرم افزار قرار دارند به صورت نسبی وارد کنید.<br>
مثال:myCert.p12<br><br>

</p><p dir="ltr">15-Do you need to change the Certificate files passwords? Enter your new password:<br></p><p dir="rtl">
رمز عبور مربوط به فایل های p12 خود را وارد کنید ( این رمز برای تمام فایل ها مشترک است )<br><br>

</p>

## <p dir="rtl">توضیحات تکمیلی</p>

<p dir="rtl">
حال صفحه تغییر می کند و نرم افزار برای خروجی گرفتن از پروژه شما آماده می شود. طبق دستور پیش رفته و گزینه مدل نسخه ی مورد نظر خود را وارد کنید تا خروجی ها برای شما ایجاد شوند. اگر هنگام خروجی گرفتن به خطایی خوردید، دستوری که خروجی شما را آماده می کند که در صفحه ی cmd قابل مشاده است را با دقت بررسی کنید تا اگر اشتباهی در پارامتر ها دیده شد مجدد آن را تنظیم کنید.<br><br><br>
از دفعات بعدی وقتی این فایل را اجرا می کنید ابتدا از شما سوال می شود که آیا تنظیمات تغییر کند یا خیر که در صورت زدن گزینه Enter خودبه خود تنظیمات قبل را استفاده می کند.<br><br>
تنظیمات مربوط به کامپایلر، فولدر فایل های نیتیو و فولدر فایل های p12 در environment vriables سیستم عامل ذخیره می شود تا برای پروژه های دیگر هم بتوان ازن همین تنظیمات استفاده کرد اما ما بقی تنظیمات تحت فایل exportparams در کنار پروژه ذخیره می ماند و شما می توانید با جابجا کردن کل پوشه روی سیستم عامل خود و یا حتی سیستم عامل دیگری از همین تنظیمات استفاده کنید.


<p>
