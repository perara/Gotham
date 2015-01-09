using System;
using System.Collections.Generic;

namespace GOTHAM.Gotham.Tools
{
  internal class HTTPRequest
  {



      public abstract class Request<T> where T : Request<T>
      {
        protected String url { get; set; }

        public T setURL(String url)
        {
          this.url = url;
          return (T)this;
        }

        public void execute()
        {
          
        }


      }

      public sealed class Post : Request<Post>
      {
        private List<String> postData { get; set; }

        public Post addPostData(String key, String value)
        {
          postData.Add(key + "=" + value);
          return this;
        }

        public Post setContentType()
        {


          return this;
        }

      }

      public sealed class Get : Request<Get>
      {

        public Get test()
        {
          return this;
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

