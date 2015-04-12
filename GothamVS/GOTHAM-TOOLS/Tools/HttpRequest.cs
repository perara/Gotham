using System;
using System.Collections.Specialized;
using System.Net;
using System.Text;

namespace Gotham.Tools
{
  public  class HttpRequest
  {
      public abstract class Request<T> where T : Request<T>
      {
        protected WebClient Client { get; set; }

        protected String Url { get; set; }

        /// <summary>
        /// Sets Destination URL 
        /// </summary>
        /// <param name="url"></param>
        /// <returns></returns>
        public T SetUrl(String url)
        {
          // Initialize the WebClient
          Client = new WebClient();

          // Set URL
          Url = url;
          return (T)this;
        }

      }

      public sealed class PostObj : Request<PostObj>
      {
        public const String ApplicationJson = "application/json";


        NameValueCollection Content { get; set; }

        public PostObj()
        {
          Content = new NameValueCollection();
        }

        /// <summary>
        /// Add a POST KVP to the Request
        /// </summary>
        /// <param name="key"></param>
        /// <param name="value"></param>
        /// <returns></returns>
        public PostObj AddPostData(String key, String value)
        {
          Content[key] = value;
          return this;
        }

       /* /// <summary>
        /// Sets the content type of the POST request (Ie application/json)
        /// </summary>
        /// <returns></returns>
        public Post setContentType(String contentType)
        {
          this.contentType = contentType;
          return this;
        }*/

        /// <summary>
        /// Execute the Request
        /// </summary>
        /// <returns></returns>
        public String Execute()
        {
        
          var response = Client.UploadValues(Url, Content);
          return Encoding.Default.GetString(response);
        }

      }

      public sealed class GetObj : Request<GetObj>
      {

        /// <summary>
        /// Execute the Request
        /// </summary>
        /// <returns></returns>
        public String Execute()
        {
          return Client.DownloadString(Url);
        }
      }

      public PostObj Post()
      {
        return new PostObj();
      }

      public GetObj Get()
      {
        return new GetObj();
      }


    }
  }

