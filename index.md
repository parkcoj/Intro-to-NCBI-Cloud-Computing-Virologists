#### This three hour workshop is being offered by the [NCBI Education Team](mailto:workshops@ncbi.nlm.nih.gov?subject=[GitHub]%20CSHL%20Cloud%20Workshop%20Feedback) on Feb 8, 2022.

**Workshop Description:** As DNA sequencing becomes a commonplace tool in biological research, the need for accessible, scalable, and secure computational environments to process this deluge of data is growing. NCBI has partnered with leading cloud computing providers to provide tools and data to this growing industry. This workshop is designed for experimental virologists without cloud computing experience. While not required, it is most useful for researchers who do sequence-based research and who have some familiarity interacting with a Linux command-line.

In this online, interactive workshop you will learn how to:

- Navigate the AWS cloud console page and understand how to access and use some popular console-based tools.
- Use the AWS Athena service to mine SRA metadata for viral information to identify an interesting dataset for further study.
- Employ traditional and cloud services to align and call consensus sequences from SRA sequence data.
- Visualize and interactively examin the aligned data using NCBI's Multiple Sequence Alignment Viewer.

---

# Objective 0 - Logging in & Navigating the AWS Console Page

1) Find your credential email with subject: **NCBI Codethon Credentials**

![img1](doc_images/img1.jpg){:width="60%"}

2) Navigate to [https://codeathon.ncbi.nlm.nih.gov](https://codeathon.ncbi.nlm.nih.gov) and login using the credentials from the email *(left image)* and create a new password after logging in *(right image)*

![img2](doc_images/img2.jpg){:width="60%"}


3) Click **Sign-In** under the AWS Console Sign-In column on the new page

![img3](doc_images/img3.jpg)

4) If you see **AWS Management Console** like the screenshot below, you have successfully logged in to the AWS Console!

![img4](doc_images/img4.jpg){:width="60%"}

> **NOTE:** If you are logged out or get kicked out of the console, simply return to [https://codeathon.ncbi.nlm.nih.gov](https://codeathon.ncbi.nlm.nih.gov) and log in again (remember your newly created password!) to get back to the console home page.

> **NOTE:** This login method is unique to the workshop. If you want to create your own account after the workshop, visit the link below and follow the steps:
> [https://aws.amazon.com/premiumsupport/knowledge-center/create-and-activate-aws-account/](https://aws.amazon.com/premiumsupport/knowledge-center/create-and-activate-aws-account/)

---

# Objective 0.5 - Create an S3 bucket to store data

Before we can properly use the cloud we need to make an S3 bucket that can save our data from each tool. So, let's go make one!

1) Use the search bar at the top of the console page to search for **S3** and click on the first result

![img5](doc_images/img5.jpg){:width="60%"}

2) Click the orange **Create Bucket** button on the right-hand side of the screen

![img6](doc_images/img6.jpg){:width="60%"}

3) Enter a bucket name and make sure the region is set to `US East (N. Virginia) us-east-1`

**S3 bucket names must be completely unique.**

For this workshop, use the format `<username>-cloud-workshop` where `<username>` is the username you used to login

![img7](doc_images/img7.jpg){:width="60%"}

4) Scroll down to the **Block Public Access settings for this bucket** section. Deselect the blue checkbox at the top and select the bottom 2 checkboxes. Then check the box underneath the warning symbol to acknowledge your changes to the public access settings

>**NOTE:** We turn on Public Access so that we can upload our files from the bucket directly to public websites like NCBI (*e.g.*, we will be uploading result files from our bucket to the Genome Data Viewer later today). By default, you should keep your bucket from Public Access unless you explicitly need it

![img8](doc_images/img8.jpg){:width="60%"}

5) Ignore the rest of the settings and scroll to the bottom of the page. Click the orange **Create Bucket** button.

![img9](doc_images/img9.jpg){:width="80%"}

6) Clicking the button will redirect you back to the main S3 page. You should be able to find your new bucket in the list. If so, you have successfully created an S3 bucket!

![img10](doc_images/img10.jpg){:width="80%"}

Now that we have an S3 bucket ready, we can go see what the Athena page looks like!

---

# Objective 1 - Aligning Sequence Reads using AWS EC2 & MagicBLAST

One of the most common uses of the cloud is simply renting some computer space from the cloud provider to run some code and generate data. Today, we'll setup an EC2 instance and import our code & data into the rented computer from the internet.

## Launching an EC2 Instance

1.1) Use the search ar at the top of the console page to search for **EC2** and click on the first result

![img25](doc_images/img25.jpg){:width="60%"}

1.2) Scroll down a little and click the orange Launch Instance button and Launch Instance from its drop-down menu

![img26](doc_images/img26.jpg){:width="60%"}

1.3) On the **Step 1: Choose an Amazon Machine Image (AMI)** page - type **Ubuntu** into the search bar and hit enter _(top image)_ then click the blue **Select** on the right hand-side of the **Ubuntu Server 20.04** image option _(bottom image)_.

![img27](doc_images/img27.jpg){:width="60%"}

![img28](doc_images/img28.jpg){:width="60%"}

1.4) On the **Step 2: Choose an Instance Type** page - use the filter menus near the top of the menu to set the Instance Family to **m6i**

![img29](doc_images/img29.jpg){:width="60%"}

1.5) Look to the table below the filter buttons and check the box in the 2nd row from the top where the type is **m6i.2xlarge**

![img30](doc_images/img30.jpg){:width="60%"}

1.6) Click **Next: Configure Instance Details**

![img31](doc_images/img31.jpg){:width="80%"}

1.7) On page **Step 3: Configure Instance Details** - set the IAM role to **NCBI-Workshop-participant-EC2-instance** _(top image)_. Leave all other settings alone and click **Next: Add Storage** in the bottom right _(bottom image)_

![img32](doc_images/img32.jpg){:width="60%"}

![img33](doc_images/img33.jpg){:width="80%"}

1.8) On page **Step 4: Add Storage** - Change the Size (GiB) to **50** _(top image)_, then click **Next: Add Tags** in the bottom right _(bottom image)_

![img34](doc_images/img34.jpg){:width="60%"}

![img35](doc_images/img35.jpg){:width="80%"}

1.9) On page **Step 5: Add Tags** - Click **Add Tag** on the left side of the screen _(top image)_. In the new row set the Key to be **Name** and the Value to be `<username>-cloud-workshop` just like we did with the S3 bucket earlier _(bottom image)_. Remember, `<username>` is the username you logged into the console with.

![img36](doc_images/img36.jpg){:width="80%"}

![img37](doc_images/img37.jpg){:width="80%"}

1.10) Click **Next: Configure Security Group** in the bottom right of the screen

![img38](doc_images/img38.jpg){:width="80%"}

1.11) On page **Step 6: Configure Security Group** - Near the top of the screen, click **Select an existing security group**. Then click the box of the **Default** row at the top.

![img39](doc_images/img39.jpg){:width="80%"}

> **NOTE:** This "default" network setting configuration leaves the instance open to public access. Typically you will want to restrict this to only trusted IP addresses, but for the purposes of the workshop we keep this open so there is no need to troubleshoot network issues. To balance this security flaw, we will restrict access to our instances with another instance feature in a few more steps.

1.12) Click **Review and Launch** in the bottom right of the screen

![img40](doc_images/img40.jpg){:width="60%"}

1.13) On page **Step 7: Review and Launch** – You should see two warnings at the top of the screen denoted by the symbol below. You can disregard these.

> **NOTE:** The first warning tells us that our instance configuration will cost us money. The second warning tells us that our network settings make our instance publicly accessible, which is discussed in the above "NOTE".

![img41](doc_images/img41.jpg){:width="20%"}

1.14) Click **Launch** in the bottom right of the screen.

![img42](doc_images/img42.jpg){:width="80%"}

1.15)	On the pop-up menu – change the first dropdown menu to **Proceed without a key pair** and check the box below it to acknowledge the change. Finally, click **Launch Instances** in the bottom right of the popup.

> **NOTE:** Key pairs are used to access this remote computer using other methods, like SSH. We won’t be using these other methods so we can skip the key pairs here without affecting our ability to do the workshop. Additionally, by disabling the key pairs we also prevent public access to the instance. (This is how we will secure our instances for the workshop)

![img43](doc_images/img43.jpg){:width="60%"}

1.16)	On the **Launch Status** page – Click **View Instances** in the bottom right

![img44](doc_images/img44.jpg){:width="60%"}

1.17)	On the **Instances** page – Find your instance in the table of created instances and look to the **Status Check** column to see the status of yours.

![img45](doc_images/img45.jpg)

1.18)	Refresh the page occasionally until the **Status Check** column changes to **2/2 checks passed** for your instance. This means we can now log into the instance.

> **NOTE:** There are several 'statuses' this column can have. 2/2 checks passed is the final status. So, if you see anything else in the **Status Check** column, the instance is not ready to go.

![img46](doc_images/img46.jpg)
 
1.19) Check the box to the left of your instance name _(top image)_ to select the instance, then click **Connect** in the top right to head to the instance launcher _(bottom image)_

![img47](doc_images/img47.jpg){:width="70%"}

![img48](doc_images/img48.jpg){:width="80%"}

1.20) On the launcher page, click **Connect** in the bottom right. This will launch a new tab in your browser and connect you to your remote computer!

![img49](doc_images/img49.jpg){:width="60%"}

## Installing Software

Before we can do our analyses, we need to install some software into our new remote computer. There are many programs necessary to make today's analysis work, so rather than typing all of that code out ourselves, I have prepared a script that we will download and run to install the programs for us.

1.21) First we need to download the script I have written for this workshop. Click the copy button on the code block below and paste it into your terminal

{% include codeHeader.html %}
```bash
wget https://raw.githubusercontent.com/parkcoj/Intro-to-NCBI-Cloud-Computing-Virologists/master/workshop_materials/EC2_workshop_installations.sh
```

1.22) Next, we need to tell our computer that this new file is a script we want to run. The following code block will give our computer permission to run the script, and then run it.

{% include codeHeader.html %}
```bash
chmod +x EC2_workshop_installations.sh &&	nohup ./EC2_workshop_installations.sh
```

> **WARNING:** This script can take up to 15 minutes to run due to the number of programs being installed. It's likely that your connection to the computer will time-out during then and you will be forced to reconnect. DON'T WORRY! The `nohup` command we added above will ensure that the installation continues even if you get disconnected. 

1.23) Now that all of our programs are installed, we need to configure the computer to access the programs with some shortcuts. The following command will create those shortcuts in our computer so it is easier to run the new programs.

{% include codeHeader.html %}
```bash
echo "export PATH=$PATH:$PWD/hisat2-2.2.1:$PWD/sratoolkit.2.11.2-ubuntu64/bin" >> .bashrc && source ~/.bashrc
```

1.24) Finally, although the installation script included the SRA Toolkit, we still need to configure it to start working. The following steps will configure the SRA Toolkit

{% include codeHeader.html %}
```bash
vdb-config -i
```

The page that opens is an interactive graphic display where we can customize the settings necessary for SRA toolkit to run. For today we only need to change one setting, so here are the buttons to hit to do that.

- `A` to change to the AWS tab
- `R` to enable reporting of your cloud identity (telling NCBI that you sent the command from an AWS computer)
- `S` to save the changes
- `X` to close the interactive browser

## Generating a Consensus Sequence for a Viral Genome

We can (finally) do the analysis we want! Like the installation process, there are a lot of steps in the analysis that each take different lengths of time to complete. To simplify and optimize this process we are going to download a second script online that does the process for us. We will walk through the steps soon, but remember that they all happen in the same script.

1.25) To download the script, run the following command:

{% include codeHeader.html %}
```bash
wget https://raw.githubusercontent.com/parkcoj/Intro-to-NCBI-Cloud-Computing-Virologists/master/workshop_materials/SRA_to_consensus.sh
```

1.26) Next, let's tell the computer it's okay to run the script...

{% include codeHeader.html %}
```bash
chmod +x SRA_to_consensus.sh
```

1.27) And finally, we run the script! I have designed the script to require us as a user to provide the SRA accession we want to build a consensus from. So the following command will run the script with our case study accession `SRR15943386`

{% include codeHeader.html %}
```bash
nohup ./SRA_to_consensus.sh SRR15943386
```

We use the `nohup` command on this script also, because it can take up to 1 hour to run! So we will let this program do its thing for a bit while we go do some other exercises. Let's navigate back to our AWS console tab and move on to some other work.

---

# Objective 2 - Search for the sequence reads deposited into NCBI's SRA database using AWS Athena

## Navigating to Athena

1) Use the search bar at the top of the console page to search for **Athena** and click on the first result

![img11](doc_images/img11.jpg){:width="60%"}

&nbsp;

2) Visiting the Athena page should prompt you with one notification about the "new Athena console experience". You can just click the "X" to remove it.

&nbsp;

![img12](doc_images/img12.jpg)

3) To make sure Athena saves our search results in the correct S3 bucket, we need to tell it which one to use. Good thing we just made one, eh?  Click **Settings** in the top left of the screen

![img13](doc_images/img13.jpg){:width="60%"}

4) Click the **Manage** button on the right *(1st image)* then **Browse S3** on the next page *(2nd image)* to see the list of S3 buckets in our account. Scroll to find your S3 bucket then click the radio button to the left of the name and click **Choose** in the bottom right *(3rd image)*. Finally, click **Save** *(4th image)*.

![img14](doc_images/img14.jpg){:width="40%"}

![img15](doc_images/img15.jpg){:width="60%"}

![img16](doc_images/img16.jpg){:width="60%"}

![img16_1](doc_images/img16_1.jpg){:width=40%"}

Now that we can save Athena results we can run some searches! The very last step to doing that is to import the table we want to search into Athena using another AWS service - Glue. However, to save time, this has already been done prior to the workshop by the instructor.

> For the detailed instructions on using AWS Glue to add a table to Athena, visit the Supplementary Text: **Instructions for AWS Glue**!

## Exploring Athena Tables

These steps aren't necessary to do before every Athena query, but they are useful when exploring a new table.

1) Navigate back to the **Editor** tab and click the dropdown menu underneath the **Database** section and click **sra** to set it as the active database. If you do not see this as an option, refresh the page and check again.

![img17](doc_images/img17.jpg){:width="80%"}

2) Look at the **Tables** section and click the ellipses next to the **metadata** table, then click **Preview Table** to automatically run a sample command which will give you 10 random lines from the table

![img18](doc_images/img18.jpg){:width="80%"}

> You can also click the **+** button next to the Metadata name to see a list of all the columns in the table.

> For SRA based tables, you can also visit the following link to get the definition of each column in the table: [https://www.ncbi.nlm.nih.gov/sra/docs/sra-cloud-based-examples/](https://www.ncbi.nlm.nih.gov/sra/docs/sra-cloud-based-examples/)

## Querying Our Dataset

1) The following link is the actual publication for our case study today. Scroll to the very bottom and find the **Data Availability** section: [https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5778042/](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5778042/)

![img19](doc_images/img19.jpg)

> You can also use the SRA Run Selector on the NCBI website to download data from NCBI directly to your S3 bucket! Find more information and a tutorial here:  
> [https://www.ncbi.nlm.nih.gov/sra/docs/data-delivery/](https://www.ncbi.nlm.nih.gov/sra/docs/data-delivery/)

2) The paper stored the data we need under and ID **SRP125431**, but we don't know exactly which column that is associated with. So, scroll through the preview table we made earlier to find a column filled with similar values.

![img20](doc_images/img20.jpg){:width="60%"}

> The **Preview Table** query we used to make this example pulls random lines from the table, so the values within your table may look different from this screenshot. The important info for us is that each value in this **sra_study** column starts with **"SRP" (or "ERP")**

3) Now that we know which column to query for our data (sra_study), we can build the Athena query. Look to the panel where we enter our Athena queries. Click **New Query 1** to navigate back to the empty panel so we can write our own query.

![img21](doc_images/img21.jpg){:width="60%"}

> Fun fact: If you navigate back to **Query 1** you should still see the result table for that query! Athena will save that view for you until you run a new query in that tab or close the webpage.

4) Copy/paste the following command into the query box in Athena _(circled in yellow)_, then click the blue **Run Query** button _(circled in red)_.

{% include codeHeader.html %}
```
SELECT *
FROM "sra"."metadata"
WHERE sra_study = 'SRP125431'
```

![img22](doc_images/img22.jpg){:width="40%"}

5) If you see a results table with three rows like the partial screenshot below, you have successfully found your data!

![img23](doc_images/img23.jpg){:width="80%"}

6) Click the **Download results** button on the top-right corner of the results panel to download your file to your computer in CSV format. You should be able to open this in Microsoft Excel, Google Sheets, or a regular text editor (e.g., Notepad for PC, TextEdit for Mac). We will review this file later, so keep it handy.

![img24](doc_images/img24.jpg){:width="60%"}

> Want to challenge yourself? Visit the supplementary text (section: **SQL challenges**) to find some questions you can build your own SQL query for. Plus, find more advanced SQL query techniques and a deeper breakdown of the SRA metadata table too!

---

# Objective 3 - Collect Consensus Sequence & Alignments

3.1) Let's navigate back to the EC2 instance we made in Objective 1 and see our progress. If you kept your original EC2 instance tab open, you can simply refresh the tab to reconnect to it.

![xx]()

3.2) To know if the script has finished, we need to check two things.
 - The script has completed running
 - The file we need is available (sequence_alignment.aln)

The script itself is designed to tell us when it is complete. In the log file `nohup.out` there should be a line that says "The script is done running! I hope this worked!". We can look for this line to check if the script is complete. So run the following command to pull the last line from the log file and see if it's done:

{% include codeHeader.html %}
```bash
tail -n 1 nohup.out
```
To see if the file we want is created, type `ls -a` to get a list of files on the EC2 instance. Look through that list for `sequence_alignment.aln` to know if we got the final file we want.

![xx]()

If the file is present, then our work is done! Next we need to move those results to our S3 bucket so we can access the data outside of our EC2 instance. Run the following AWS CLI command to copy the files to your S3 bucket.

> **REMEMBER:** You will need to replace the `<username>` piece of the command with your own login username to make it match your S3 bucket name. So copy/paste the command into your terminal, then use the arrow keys to move your cursor back through the string and change the name to your own bucket.

{% include codeHeader.html %}
```bash
aws s3 cp sequence_alignment.aln s3://<username>-cloud-workshop
```

3.3) To prove that we successfully moved the file to our s3 bucket we can run one final command (remember to change the `<username>` portion again here):

{% include codeHeader.html %}
```bash
aws s3 ls s3://<username>-cloud-workshop
```

3.4)	We should now be done with our remote computer (aka: EC2 instance). Go ahead and close the browser tab your instance is open in.

![img50B](doc_images/img50B.jpg){:width="60%"}

3.5)	In the console webpage, click the blue **Instances** button at the top of the instance launcher page

![img51](doc_images/img51.jpg){:width="60%"}

3.6) We don’t want to leave an instance on while not using it, because it costs money to keep it active. So, let’s shut it down, but not delete it, just in case we want to use it later. Check the box next to your instance _(top image)_ then click the **Instance State** drop-down menu and select **Stop Instance** _(bottom image)_.

![img52](doc_images/img52.jpg){:width="70%"}

![img53](doc_images/img53.jpg){:width="60%"}

3.7) Finally, we need to check on the file in our S3 bucket and download it for use in our final Objective. Navigate back to the S3 page (use the search bar at the top of the console page) _(top image)_ and click on your bucket name _(bottom image)_ to see its contents

![img54](doc_images/img54.jpg){:width="60%"}

![img55](doc_images/img55.jpg){:width="60%"}

3.8) You should see the file in your S3 bucket. Simply click on the checkbox next to the filename and select `Download` from the list of options at the top of the page

![img56](doc_images/img56.jpg){:width="60%"}

![img57](doc_images/img57.jpg){:width="40%"}

# Objective 4 - Visualize Sequence Alignments Using Sequence Viewer

## Importing Our Data

4.1)	Open a new tab in your web browser and go to [https://www.ncbi.nlm.nih.gov/projects/sviewer/](https://www.ncbi.nlm.nih.gov/projects/sviewer/)

4.2)	Click **enter an accession or gi** to choose the reference sequence. We aligned our sequence against the NCBI RefSeq record NC_045512, so enter the accession **NC_045512** into the box provided and click **OK**

![img63](doc_images/img63.jpg){:width="60%"}

The Sequence Viewer page comes pre-loaded with several tracks aligned against the chromosome. Most of these are not useful to us today, so let's configure the page to be a bit easier to read.

4.3) Click the **Tracks** button in the top-right corner of the viewer page and select **Configure Tracks**

![img65](doc_images/img65.jpg){:width="60%"}

4.4) Deselect all of the tracks on this page **except Sequence & Genes** to remove those tracks from the Sequence Viewer panel.

![xx]()

4.5) Click **Configure** at the bottom to save the changes.

![xx]()

4.6) To add our own data track, open the **Configure Tracks** menu again and select the **Custom Data** tab at the top of the pop-up menu

![xx]()

4.7) We did a sequence alignment, so let's choose the **Alignment MUSCLE/FASTA** Data Source as our type of data to upload.

![xx]()

4.8) Next, find the file we downloaded from our S3 bucket and drag-and-drop it onto the upload box. You can also use the Browse button if that is more convenient for you. You should also provide a name for the track so it is easy to identify in the Sequence Viewer. Here I use **SRR15943386 Alignment**. Click **Upload** to add the track to the Sequence Viewer

![xx]()

4.9) Click **Configure** to see the track on your Sequence Viewer

![xx]()

> **NOTE:** When the track is first uploaded you may see a long red bar. This is a graphical bug. It will resolve itself as we continue with the exercise

4.10) The mutation we are looking for is found in the S protein. Click-and-drag your mouse across the coordinate plot at the top of the Sequence Viewer to outline the region of the genome where the S protein is located (it does not have to be exact). Select **Zoom on Range** from the pop-up menu to refocus the viewer on that highlighted region.

![xx]()

The alignment track shows each point of variation between the RefSeq Sars-CoV-2 sequence and our own sequence. Below are a few of the common variations:
- Horizontal red bar -or- Vertical blue bar: A gap in the alignment
- Vertical red bar: The nucleotide at that position differs from the reference

4.11) <Stuff about finding the right mutation in the alignment>

---

# Conclusion

This concludes our exercise on navigating the AWS Cloud computing console and several of its most popular cloud services. We hope that you are motivated to take these skills and tools with you and explore how they can benefit your own research. You can find links to many useful resources to help you below.

---

# Useful URLs

- Case Study - [https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5778042/](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5778042/)

**AWS**

- AWS Account Creation: [https://aws.amazon.com/premiumsupport/knowledge-center/create-and-activate-aws-account/](https://aws.amazon.com/premiumsupport/knowledge-center/create-and-activate-aws-account/)
- AWS Athena Documentation: [https://docs.aws.amazon.com/athena/](https://docs.aws.amazon.com/athena/)
- AWS Billing: [https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/billing-what-is.html](https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/billing-what-is.html)
- Cost Estimator: [https://calculator.aws/#/estimate](https://calculator.aws/#/estimate)
- AWS CLI Documentation: [https://docs.aws.amazon.com/cli/index.html](https://docs.aws.amazon.com/cli/index.html)
- AWS EC2 Instance Documentation: [https://docs.aws.amazon.com/ec2/index.html](https://docs.aws.amazon.com/ec2/index.html)
- AWS Glue Documentation: [https://docs.aws.amazon.com/glue/](https://docs.aws.amazon.com/glue/)
- AWS S3 Bucket Documentation: [https://docs.aws.amazon.com/s3/index.html](https://docs.aws.amazon.com/s3/index.html)

**Genome Data Viewer**

- Genome Data Viewer: [https://www.ncbi.nlm.nih.gov/genome/gdv/](https://www.ncbi.nlm.nih.gov/genome/gdv/)
- Sequence Viewer Documentation: [https://www.ncbi.nlm.nih.gov/tools/sviewer/](https://www.ncbi.nlm.nih.gov/tools/sviewer/)

**MagicBLAST**

- MagicBLAST Documentation: [https://ncbi.github.io/magicblast/](https://ncbi.github.io/magicblast/)
- MagicBLAST FTP page: [ftp://ftp.ncbi.nlm.nih.gov/blast/executables/magicblast/LATEST](ftp://ftp.ncbi.nlm.nih.gov/blast/executables/magicblast/LATEST)
- SamTools Documentation: [http://www.htslib.org/](http://www.htslib.org/)

**SRA**

- SRA Homepage: [https://www.ncbi.nlm.nih.gov/sra](https://www.ncbi.nlm.nih.gov/sra)
- SRA in the Cloud: [https://www.ncbi.nlm.nih.gov/sra/docs/sra-cloud/](https://www.ncbi.nlm.nih.gov/sra/docs/sra-cloud/)

---

# Supplementary Information

## Instructions for AWS Glue

In order search through a table (like the SRA metadata table) you need to load it into Athena. Because this is your first-time accessing Athena, it shouldn't be a surprise that you don't currently have any data tables loaded! Therefore, our first step will be to add the SRA metadata table to Athena. There are three ways you can add a table to Athena:

1.	Create the table using SQL commands (we are not SQL experts here...yet, so we won't do it this way)

2.	Add the table manually from an S3 bucket (although the SRA metadata is stored in its own S3 bucket, we don't know the format of the table, so we can't do it this way)

3.	**Use another AWS service called AWS Glue to automatically parse a table and load it into Athena for us using a "Crawler" (this is what we will do)**

> **Note:** Although AWS Glue is the most convenient method, it is also the only one to cost money. To parse the SRA metadata table it will be... ~$0.01.

This section will walk through the steps taken during the AWS Glue demo to prepare the SRA metadata table for Athena queries

1) To start working with AWS Glue, navigate to the **Tables** section of the Athena page on the left-hand side, then click **Create Table** and select **from AWS Glue Crawler** as seen below. If you see a pop-up about the crawler, just click **Continue**.

![img86](doc_images/img86.jpg){:width="60%"}

2) The settings for this crawler should e set as described below:

- Crawler name: This name needs to be informative, but not universally unique (like an S3 bucket). Choose something that helps you remember what the crawler is trying to access.

**Next page**

- Crawler Source Type: Keep the default setting (**data stores**)
- Repeat crawls of S3 data stores: Keep the default setting (**Crawl all folders**)

**Next page**

- Choose a data store: Set it to **S3**
- Connection: Leave empty
- Crawl data in: Select **Specified path in another account**
- Include path: This is the path to the table itself. The SRA metadata table used here is located at **s3://sra-pub-metadata-us-east-1/sra/metadata/**

**Next page**

- Add another data store: Select **No**. However, crawlers *can* parse multiple tables at a time, so you can add this if you want.

**Next page**

- Choose an IAM role: Work with your admin to determine the correct choice for you. If you are doing this on your own, I recommend creating your own IAM role and reusing it if you need additional crawlers.

**Next page**

- Frequency: Select **Run on Demand**. Crawlers can be run on specified intervals, but this costs extra money, and for most purposes is unecessary.

**Next page**

- Database: Select **Add database** then make a name for it. The tables parsed by this crawler will be stored in this database. Then click **Create**.
- Prefix added to tables (optional) - Leave empty.

**Next Page**

**Click Finish**

3) You should now be on the **Crawler** page for AWS Glue. Here you can manage and run crawlers. Click the checkbox next to the new crawler and select **Run Crawler**

![img87](doc_images/img87.jpg){:width="80%"}

4) If it worked, you should see the **Status** column say **Ready** again, and the **Tables added** column should have changed to 1:

![img88](doc_images/img88.jpg){:width="80%"}

5) The table should now appear in Athena and you can follow the same steps described in section **Exploring Athena Tables** above.

## SQL Challenges

Now that you have a handle on how SQL commands work, let’s try some examples! Remember, you can use the “Tables” section on the left-hand side of the page to find out which columns you can filter by in your table.

If you find yourself stumped on the answer to any of these, or just want to check your answer, click the dropdown box underneath the question to reveal the solution and see a screenshot of the results table!

a) You just came across a new paper with lots of great sequence data. You want to add that data to your own research so you jump to the paper's Data Availability section (because all great computational papers have one!) and see that the data was stored in an SRA study under the accession SRP291000. Write a SQL command in the query terminal to find all data associated with the SRA study accession SRP291000:

{::options parse_block_html="true" /}
<details><summary markdown="span">**Click here to see solution!**</summary>
```SELECT * FROM "sra"."metadata" WHERE sra_study = 'SRP291000'```
![img89](doc_images/img89.jpg)
</details>
<br/>
{::options parse_block_html="false" /}


b) You are working on a new genome assembly tool for short-read sequences. However, you don't have any reads of your own to test it! You know that SRA metadata includes the sequencing platform reads were generated on, so you decide you want to check there. Write a SQL command in the query terminal to find all data sequenced with the OXFORD_NANOPORE platform.

{::options parse_block_html="true" /}
<details><summary markdown="span">**Click here to see solution!**</summary>
```SELECT * FROM "sra"."metadata" WHERE platform = 'OXFORD_NANOPORE'```
![img90](doc_images/img90.jpg)
</details>
<br/>
{::options parse_block_html="false" /}


Now let’s get a little bit more complicated with our queries by combining multiple filtering conditions together. For example, see the command below:

![img91](doc_images/img91.jpg){:width="80%"}

In this command we use the **AND** statement to add multiple requirements for our data. Specifically, we added a second criteria where the _consent = public_ (aka: The data is not under restricted access). Additionally, we add a more complex requirement by using an **OR** statement for the _platform_ column to ask for data that was generated by the _OXFORD_NANOPORE OR PACBIO_SMRT_ sequencing platforms. Overall, by running this command we will only get the data that fits all 3 conditions.

> **Note:** Make sure you include parenthesis around an OR statement as seen above, otherwise the query may not work as intended.

Here’s a few brain teasers to flex your new SQL skills! Remember, if you are stuck you can click the dropdown box underneath the question to reveal the solution and see a screenshot of the results table!

a)	After testing your genome assembly tool from earlier, you realize that not all Illumina datasets are created equally! It turns out you only need WGS (Whole Genome Sequencing) genomic data to properly validate your software. Also, you noticed that there was some metagenomic and transcriptomic data mixed in with your test cases. So, this time you are just going to look for “genomic” datasets. Write a SQL command in the query terminal to find all **WGS assay_type** data sequenced on the **ILLUMINA platform** and a **GENOMIC library_source**.

{::options parse_block_html="true" /}
<details><summary markdown="span">**Click here to see solution!**</summary>
```SELECT * FROM "sra"."metadata" WHERE platform = 'ILLUMINA' AND assay_type = 'WGS' AND librarysource = 'GENOMIC'```
![img92](doc_images/img92.jpg)
</details>
<br/>
{::options parse_block_html="false" /}


b) You are designing a population-level epidemiological survey of some bacterial pathogens from samples collected across Europe. You decide you want to get some preliminary data on _Escherichia coli_ (or maybe _Staphylococcus aureus_...) from the SRA, but you aren’t picky about what kind of sequencing is done just yet. Write a SQL command in the query terminal to find all sequences collected from the **continent Europe** and are from the **organism Escherichia coli or Staphylococcus aureus**.

_Hint: The column header for the continent is not very intuitive. Try using the “Preview Table” option from the “Tables” tab described earlier to find a column that would fit._

{::options parse_block_html="true" /}
<details><summary markdown="span">**Click here to see solution!**</summary>
```SELECT * FROM "sra"."metadata" WHERE (organism = 'Escherichia coli' OR organism = 'Staphylococcus aureus') AND geo_loc_name_country_continent_calc = 'Europe'```
![img93](doc_images/img93.jpg)
</details>
<br/>
{::options parse_block_html="false" /}
