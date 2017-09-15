---
layout: post
title: Mocking remoteAddr with Spring-mvc
date: 2014-11-12 03:00:42 +1030
categories:
- Software Development
author: Tom Saleeba
---
# The problem

We developed a Spring MVC controller that needs to know who the client is. We achieved this using a `HttpServletRequest` parameter and then calling `getRemoteAddr()` on it. The challenge then was how to test this because we need to be able to mock this value.

# The fix

The Spring test helpers don't provide a way to set this value with a helper method but they do provide an extension point that we can use to do it ourselves. The extension point is the `.with(RequestPostProcessor)` method:
```java
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.is;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
import static org.springframework.test.web.servlet.setup.MockMvcBuilders.webAppContextSetup;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.ResultHandler;
import org.springframework.test.web.servlet.request.RequestPostProcessor;
import org.springframework.web.context.WebApplicationContext;

@RunWith(SpringJUnit4ClassRunner.class)
@WebAppConfiguration
@ContextConfiguration(locations = { "classpath:test-servlet-context.xml" })
public class RestDoThingControllerTest {

  @Autowired
  private WebApplicationContext wac;

  private MockMvc mockMvc;

  @Before
  public void setup() {
    this.mockMvc = webAppContextSetup (this.wac).build();
  }

  /**
   * Can we do that thing?
   */
  @Test
  public void testdoThing01() throws Exception {
    ResultHandler assertPayloadIsAccepted = new ResultHandler() {
      @Override
      public void handle(MvcResult result) throws Exception {
        assertThat(result.getResponse().getContentAsString(), is("some payload"));
      }
    };
    mockMvc.perform(post("/doThing")
        .with(remoteAddr("192.168.0.1")) // we can supply a mock IP now :D
        .content("some payload"))
            .andExpect(status().isOk())
            .andDo(assertPayloadIsAccepted);
  }

 private static RequestPostProcessor remoteAddr(final String remoteAddr) { // it's nice to extract into a helper
    return new RequestPostProcessor() {
      @Override
      public MockHttpServletRequest postProcessRequest(MockHttpServletRequest request) {
        request.setRemoteAddr(remoteAddr);
        return request;
      }
    };
  }
}
```

You can then easily move our static helper method to some other class and then use it wherever you like. You can even have it as readable as it is here thanks to `import static ...`.
