using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Net;
using System.Net.Http;
using System.Text;
using Community.CsharpSqlite;
using IronPython.Runtime.Exceptions;

namespace GOTHAM.Gotham.Tools
{
  public  class HTTPRequest
  {



      public abstract class Request<T> where T : Request<T>
      {
        protected WebClient client { get; set; }

        protected String url { get; set; }

        /// <summary>
        /// Sets Destination URL 
        /// </summary>
        /// <param name="url"></param>
        /// <returns></returns>
        public T setURL(String url)
        {
          // Initialize the WebClient
          client = new WebClient();

          // Set URL
          this.url = url;
          return (T)this;
        }

      }

      public sealed class Post : Request<Post>
      {
        public const String APPLICATION_JSON = "application/json";


        NameValueCollection content { get; set; }
        private String contentType { get; set; }

        public Post()
        {
          content = new NameValueCollection();
        }

        /// <summary>
        /// Add a POST KVP to the Request
        /// </summary>
        /// <param name="key"></param>
        /// <param name="value"></param>
        /// <returns></returns>
        public Post addPostData(String key, String value)
        {
          content[key] = value;
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
        public String execute()
        {
        
          var response = client.UploadValues(url, content);
          return Encoding.Default.GetString(response);
        }

      }

      public sealed class Get : Request<Get>
      {

        /// <summary>
        /// Execute the Request
        /// </summary>
        /// <returns></returns>
        public String execute()
        {
          return client.DownloadString(url);
        }
      }

      public Post POST()
      {
        return new Post();
      }

      public Get GET()
      {
        return new Get();
      }


    }
  }

